#
# ~/.bashrc
#

# If not running interactively, don't do anything
txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
bakgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset

[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '
#PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]\n\[\033[32m\]\w\n\[\033[0;33m\]** \# ** \[\033[1;34m\]\$(/bin/date) \[\033[0;35m\]\u@\h: \[\033[0;36m\]\$(/usr/bin/tty | /bin/sed -e 's:/dev/::'): \$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files \$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b \n\[\033[0;37m\]-> \[\033[0;31m\]"

PS1="\n$txtgrn\w\a\n$txtylw** \# ** $bldblu\$(/bin/date) $txtpur\u@\h: $txtcyn\$(/usr/bin/tty | /bin/sed -e 's:/dev/::'): \$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files \$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b$txtrst\n-> "

alias ls='ls --color=auto'
alias ll='ls -al'
alias vi='vim'
complete -cf sudo
complete -cf *
alias beep="beep -f 5000 -l 50 -r 2"
alias sudo="sudo "
alias tree='tree -C'
alias grep='grep --color'

function grivex () {
	if pwd | grep -vq "Google Drive$"; then
		echo Not in Google folder
		return
	fi
	rm ~/.xmonad/xmonad{.hi,.o,.errors,-x86_64-linux} 2> /dev/null
	rm ~/.xmonad/prompt-history 2> /dev/null
	rm ~/.xmonad/xmonad-git # remove soft link
	grive --ignore=".stack-work"
	ln -s ~/xmonad-git ~/.xmonad/xmonad-git # readd soft link
}

function sshnasty () {
	if [ -z $1 ]; then return; fi
	for K in "$@"; do sed -i "$K"d ~/.ssh/known_hosts; done
}
PATH=$PATH:/home/dvmacias/.local/bin
alias urgent="sleep 2; echo -e '\a'"

# lxterminal needs this
#if [ $TERM = xterm ] ; then
#   unset PROMPT_COMMAND
#fi

export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}\007"'
export EDITOR=/usr/bin/vim

alias jcontrol='/usr/lib/jvm/java-9-jdk/bin/jcontrol'

#if [ -z "$SSH_AUTH_SOCK" ] ; then
#  eval `ssh-agent -s`
#  ssh-add
#fi
