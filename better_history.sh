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

#Prepare ~/.my_history based on the user's shell
ARGS=$@
if [ "$SHELL" == "/usr/bin/zsh" ] || [ "`readlink $SHELL`" == "zsh" ]; then
	#ZSH
	if [ "$1" == "" ] || [ "$1" == "rofi" ]; then
		cat ~/.zsh_history | sed 's/.*:0;//' | awk '!x[$0]++' | tac | sed '/^h /d' > ~/.my_history
	else
		cat ~/.zsh_history | sed 's/.*:0;//' | grep "$ARGS" | tac | awk '!x[$0]++' | sed '/^h /d' > ~/.my_history
	fi
else
	#USE BASH AS DEFAULT (NOT TESTED)
	if [ "$1" == "" ] || [ "$1" == "rofi" ]; then
		 cat .bash_history | awk '!x[$0]++' | tac | sed '/^h /d' > ~/.my_history;
	else
		 cat .bash_history | grep "$ARGS" | tac | awk '!x[$0]++' | sed '/^h /d' > ~/.my_history;
	fi
fi

#Check if there are any results
if [ "`wc -l ~/.my_history|sed 's/ .*//'`" == "0" ];then
	echo >&2 "Nothing..."
	exit 229;
fi

#Check if argument is rofi, otherwise use dialog
if [ "$1" == "rofi" ];then
	command -v dialog >/dev/null 2>&1 || {
		echo -e >&2 "Package \"rofi\" is needed\n - Archlinux : sudo pacman -S rofi\n - Debian : sudo apt-get install rofi";exit 231;
	}
	command=`cat .my_history| rofi -dmenu`
	echo "$command"  >> ~/.my_history_selection
	if [ "$command" != "" ];then
		notify-send "CLIPBOARD : $command"
		#termite -e ""
	fi
else
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
	command="${commands[`expr $choice - 1`]}"
	if [ "$command" != "" ];then
		echo "CLIPBOARD : $command"
		notify-send "CLIPBOARD : $command"
		echo -n "$command" | xclip -selection c
		### future usage (see Todo in README.md) ###
		echo "$command" >> ~/.my_history_selection
	fi
fi

#if [ "$command" != "" ];then
#	echo "CLIPBOARD : $command"
#	echo -n "$command" | xclip -selection c
#	### future usage (see Todo in README.md) ###
#	echo "$command" >> ~/.my_history_selection
#fi
#
