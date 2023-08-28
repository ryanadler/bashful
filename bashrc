# place into your home directory at ~/.bashrc
# Makes the assumption you have the following installed:
# tree, gpg, vi, vim

# Bash Entries:
alias asdf='.~/.bashrc'
alias edit='vim ~/.bashrc'
alias list='tree -L l'
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
