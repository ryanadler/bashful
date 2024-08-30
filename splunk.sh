# These alises are designed for use on Splunk Enterprise systems as shortcuts for admins

alias home='cd $SPLUNK_HOME/etc'
alias splunkd='tail -f $SPLUNK_HOME/var/log/splunk/splunkd.log'
alias reload='echo "/opt/splunk/bin/splunk reload deploy-server -timeout 180" && splunk reload deploy-server -timeout 180'


# Splunk Specific Functions

## Cluster Functions
validate () {
	# This function and the host variable is predicated on a naming convention of your Splunk Systems, and their location in local/inputs.conf
        host=$(cat $SPLUNK_HOME/etc/system/local/inputs.conf | grep -oE "splunk_\w+")

        if [[ "$host" == *"splunk_cluster_manager"* ]]; then
                echo "Splunk Index Cluster Manager: Running `splunk validate cluster-bundle --check-restart`"
                splunk validate cluster-bundle --check-restart

        else
                echo "This system is not identified as a Cluster Manager, exiting"
        fi
}

bundle () {
	# This function and the host variable is predicated on a naming convention of your Splunk Systems, and their location in local/inputs.conf
	host=$(cat $SPLUNK_HOME/etc/system/local/inputs.conf | grep -oE "splunk_\w+")
	
	if [[ "$host" == *"splunk_cluster_manager"* ]]; then
		echo "Splunk Index Cluster Manager: Running `splunk apply cluster-bundle`"
		splunk apply cluster-bundle

	elif [[ "$host" == *"splunk_search_deployer"* ]]; then
		target=$(cat $SPLUNK_HOME/var/log/splunk/conf.log | grep -oE https://[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+ | tail -1 | sed 's/https:\/\///g')
		echo "Splunk Search Head Cluster Deployer: Running `splunk apply shcluster-bundle -target $target --answer-yes`"
		splunk apply shcluster-bundle -target $target --answer-yes
	else
		echo "This system is not identified as either a Cluster Manager or Search Deployer, exiting"
	fi
}

dsclient () {
	echo && splunk dispatch '|rest /services/deployment/server/clients splunk_server=local | search clientName IN("'$1'") OR instanceName IN("'$1'") OR hostname IN("'$1'") | fields applications.*serverclasses | transpose | rename column as headers, "row 1" as serverclass | search serverclass=* | sort -headers | rex field="headers" "applications\.(?<app>\S+)\.serverclasses" | fields serverclass app | sort + serverclass | rex mode=sed field=serverclass "s/$/    /g" | eventstats dc(app) as appCount by serverclass | eval appCount=appCount." " | fields appCount serverclass app' && echo
}

de () {
        # usage is de 'valueOfpass4SymmKeyhere'
        # example: de '$7$9sdf093093nosdf98sdg093n094g09h09hsd'
        # you must include encapsulating single quotes to pass the value properly

        splunk show-decrypted --value $1
        echo
}


en () {
        # usage is en 'plainvalueOfpass4SymmKeyhere'
        # example: en 'this84dnifsmpassword!!$'
        # you must include encapsulating single quotes to pass the value properly

        splunk show-encrypted --value $1
        echo
}

## Logon Information Block - systemd control vs init.d or no boot-start
. /opt/splunk/bin/setSplunkEnv && echo && systemctl status splunk | grep Active -C4 && echo 
#. /opt/splunk/bin/setSplunkEnv && echo && splunk status
