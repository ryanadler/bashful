# These alises are designed for use on Splunk Enterprise systems as shortcuts for admins
# It is recommended you add the following line to the end of your `/etc/profile` :
# . /opt/splunk/bin/setSplunkEnv
# This will set your Splunk Home enviroment for the system
# You can also consider adding :
# echo && systemctl status splunk | grep -C 3 Active && echo
# If you are running splunk with systemd, so you get a Splunk Status everytime you log into a system

alias home='cd $SPLUNK_HOME/etc'
alias splunkd='tail -f $SPLUNK_HOME/var/log/splunk/splunkd.log'
alias reload='echo "/opt/splunk/bin/splunk reload deploy-server -timeout 180


# Splunk Specific Functions

bundle () {
	# This function and the host variable is predicated on a naming convention of your Splunk Systems, and their location in local/inputs.conf
	host=$(cat $SPLUNK_HOME/etc/system/local/inputs.conf | grep -oE "splunk_\w+")
	
	if [[ "$host" == *"splunk_cm"* ]]; then
		echo "Splunk Index Cluster Manager: Running `splunk apply cluster-bundle`"
		splunk apply cluster-bundle

	elif [[ "$host" == *"splunk_shcd"* ]]; then
		target=$(cat $SPLUNK_HOME/var/log/splunk/conf.log | grep -oE https://[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+ | tail -1 | sed 's/https:\/\///g')
		echo "Splunk Search Head Cluster Deployer: Running `splunk apply shcluster-bundle -target $target --answer-yes`
		splunk apply shcluster-bundle -target $target --answer-yes
	else
		echo "This system is not identified as either a Cluster Manager or Search Deployer, exiting"
	fi
}


