## Assumptions: installation of tree git vim gpg
## This can be used as a global bash configuration or a local ~./bashrc
## If being used as a global-bash.sh, place into your /etc/profile.d directory
## definitely place the git-prompt.sh into your /etc/profile.d directory, as it allows for git bash information



# Bash Entries:
alias asdf='. ~/.bashrc'
alias edit='vim ~/.bashrc'
alias list='tree -L 1'
alias v='vim'

# Credential Specific Entries
function remake () {
	if [[ "$1" == "aws" ]]; then
		rm -f ~/.aws/credentials.gpg && gpg --output ~/.aws/credentials.gpg --symmetric ~/.aws/credentials
	elif [[ "$1" == "git" ]]; then
		rm -f ~/.git-credentials.gpg && gpg --output ~/.git-credentials.gpg --symmetric ~/.git-credentials
	else
		echo "command not recognized, please use either an argument of `aws` or `git`"
	fi
}
alias lock='rm -f ~/.aws/credentials ~/.git-credentials'
alias unlock='gpg --no-symkey-cache -o ~/.aws/credentials -d ~/.aws/credentials.gpg && gpg --no-symkey-cache -o ~/.git-credentials -d ~/.git-credentials.gpg'

# Git Entries
alias add='git add -A :/ && git status'
alias diff='git diff'
alias push='branch=$(git rev-parse --abbrev-ref HEAD) && git push -u origin $branch'
alias gb='git branch'
alias status='git status'

# Git Bash Prompt

function parse_git_dirty {
	  [[ $(git status --porcelain 2> /dev/null) ]] && echo "*"
  }
function parse_git_branch {
	  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$(parse_git_dirty))/"
  }

# Git Master/Main Checkout Function
master () {
        status=$(git branch | grep -E "main|master" | sed 's/* //g' | sed 's/  //g')

        if [ $status == "main" ]; then

                echo "main branch identified"
                git checkout main && git pull

        elif [ $status == "master" ]; then
                echo "master branch identified"
                git checkout master && git pull
        else
                echo "error"
        fi
}

main () {
        status=$(git branch | grep -E "main|master" | sed 's/* //g' | sed 's/  //g')

        if [ $status == "main" ]; then

                echo "main branch identified"
                git checkout main && git pull

        elif [ $status == "master" ]; then
                echo "master branch identified"
                git checkout master && git pull
        else                                                                                                                                        echo "error"
        fi                                                                                                                          }

# Bash Exports
export HISTTIMEFORMAT='%F %T  '
export LS_COLORS=$LS_COLORS:'ow=1;34:';
export PS1="\t \u \[\033[32m\]\w\[\033[33m\]\$(GIT_PS1_SHOWUNTRACKEDFILES=1 GIT_PS1_SHOWDIRTYSTATE=1 __git_ps1)\[\033[00m\]\n$ "

#source ~/git-prompt.sh
#source ~/splunk.sh

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
	  exec tmux
fi
