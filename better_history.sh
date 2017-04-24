#!/bin/bash
#Creator : https://github.com/justUmen
#Link : https://github.com/justUmen/better_history

#OPTIONS FOR ROFI
TERMINAL="xterm" #Terminal need to support option -e, like xterm, lxterminal...
ROFI_AUTORUN=1 # =1 to automatically launched the selected command in a terminal.
#After autorun, the default shell is executed

#Check dependancies :
command -v xclip >/dev/null 2>&1 || {
	echo -e >&2 "Package \"xclip\" is needed\n - Archlinux : sudo pacman -S xclip\n - Debian : sudo apt-get install xclip";exit 231;
}

#Prepare ~/.my_history based on the user's shell
ARGS=$@
if [ "$SHELL" == "/usr/bin/zsh" ] || [ "`readlink $SHELL`" == "zsh" ]; then
	#ZSH
	if [ "$1" == "" ] || [ "$1" == "rofi" ]; then
		cat ~/.zsh_history | sed 's/.*:[0-9]*;//' | awk '!x[$0]++' | tac | sed '/^h /d' > ~/.my_history
	else
		cat ~/.zsh_history | sed 's/.*:[0-9]*;//' | grep "$ARGS" | tac | awk '!x[$0]++' | sed '/^h /d' > ~/.my_history
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
	#GUI - Graphical User Interface
	command -v rofi >/dev/null 2>&1 || {
		echo -e >&2 "Package \"rofi\" is needed\n - Archlinux : sudo pacman -S rofi\n - Debian : sudo apt-get install rofi";exit 231; #not tested for debian, rofi in repo ???
	}
	command=`cat .my_history| rofi -fullscreen -dmenu`
	echo "$command"  >> ~/.my_history_selection
	if [ "$command" != "" ];then
		echo -n "$command" | xclip -selection c
		notify-send "CLIPBOARD : $command"
		if [ "$ROFI_AUTORUN" == "1" ];then
			$TERMINAL -e "$command;$SHELL"
		fi
	fi
else
	#CLI - Command Line Interface
	command -v dialog >/dev/null 2>&1 || {
		echo -e >&2 "Package \"dialog\" is needed\n - Archlinux : sudo pacman -S dialog\n - Debian : sudo apt-get install dialog";exit 231;
	}
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

## Code explanations :
#1. remove duplicates from the list : `awk '!x[$0]++'`
#2. remove the "h" alias itself from the result : `sed '/^h /d'`
#3. reverse the list, last commands stay top : `tac`
#4. clean "zsh_history" into plain text : `sed 's/.*:0;//'`
#5. use `readlink` if for example "/bin/sh" is a link towards "/usr/bin/zsh"
