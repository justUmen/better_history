#!/bin/bash
#Creator : https://github.com/justUmen
#Link : https://github.com/justUmen/better_history

#Check dependancies :
command -v dialog >/dev/null 2>&1 || {
	echo -e >&2 "Package \"dialog\" is needed\n - Archlinux : sudo pacman -S dialog\n - Debian : sudo apt-get install dialog";exit 231;
}
command -v xclip >/dev/null 2>&1 || {
	echo -e >&2 "Package \"xclip\" is needed\n - Archlinux : sudo pacman -S xclip\n - Debian : sudo apt-get install xclip";exit 231;
}

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
