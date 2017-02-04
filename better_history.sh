#!/bin/bash
#Creator : https://github.com/justUmen
# This program enhances the access of the user's history with regex and a dialog list.
# The user can then paste the wanted command using Ctrl + Shift + v
#It is supposed to be use with an alias : alias h="/path/to/this/script"
#It is supposed to be launched with a simple "h whatever"

#Todo :
# - support for more shells
# - usage of ~/.my_history_selection to sort by most used command, rather than last used commands
# - improve unreliable regex (sed 's/.*:0;//')
# - version with rofi ?

#Check dependancies :
command -v dialog >/dev/null 2>&1 || {
	echo -e >&2 "Package \"dialog\" is needed\n - Archlinux : sudo pacman -S dialog\n - Debian : sudo apt-get install dialog";exit 231;
}
command -v xclip >/dev/null 2>&1 || {
	echo -e >&2 "Package \"xclip\" is needed\n - Archlinux : sudo pacman -S xclip\n - Debian : sudo apt-get install xclip";exit 231;
}

# - Use the default shell, based on $SHELL environment variable

# 1 - remove duplicates from the list : awk '!x[$0]++'
# 2 - remove "h" command itself : sed '/^h /d'
# 3 - reverse the list, last commands stay top : tac
# 4 - clean zsh_history : sed 's/.*:0;//'
# 5 - use readlink if /bin/sh is a link towards /usr/bin/zsh

ARGS=$@
if [ "$SHELL" == "/usr/bin/zsh" ] || [ "`readlink $SHELL`" == "zsh" ]; then
	#ZSH
	if [ "$1" == "" ]; then
		cat ~/.zsh_history | sed 's/.*:0;//' | awk '!x[$0]++' | sed '/^h /d' > ~/.my_history
	else
		cat ~/.zsh_history | sed 's/.*:0;//' | grep "$ARGS" | tac | awk '!x[$0]++' | sed '/^h /d' > ~/.my_history
	fi
else
	#USE BASH AS DEFAULT (NOT TESTED)
	if [ "$1" == "" ]; then
		 cat .bash_history | awk '!x[$0]++' | sed '/^h /d' > ~/.my_history;
	else
		 cat .bash_history | grep "$ARGS" | tac | awk '!x[$0]++' | sed '/^h /d' > ~/.my_history;
	fi
fi

if [ "`wc -l ~/.my_history|sed 's/ .*//'`" == "0" ];then
	echo >&2 "Nothing..."
	exit 229;
fi

cmd=(dialog --nocancel --keep-tite --menu "Select command for your clipboard:" 100 100 100)
options=()
commands=()
CMP=1
while read line; do
	options+=($CMP "$line")
	commands+=("$line")
	CMP=`expr $CMP + 1`
done < ~/.my_history
choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
echo "CLIPBOARD : ${commands[`expr $choice - 1`]}"
echo -n "${commands[`expr $choice - 1`]}" | xclip -selection c

#ADD THIS SELECTION FOR A LIST OF THE BEST SELECTION
echo "${commands[`expr $choice - 1`]}" >> ~/.my_history_selection
