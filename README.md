# better_history.sh

This script gives a simple interactive access to the user's history.  
The selected command is then put in the clipboard using xclip.  
The user can then paste the command using Ctrl + Shift + v in the terminal.  

This script do not change the history file and should work in all situations.

It is supposed to be launched with a simple "h whatever"  
With the help of an alias : `alias h="/path/to/this/script"` (in ".bashrc" file, ".zshrc",  etc...)

Especially useful when you try to use a long command you used a long time ago.
If you remember that the command contain the word "debug", you can use "h debug" to find it back quickly in its integrity.

Works better with a big history record :  
`export HISTSIZE=10000` (in ".bashrc" file, ".zshrc",  etc...)

##Use rofi interface with shortcut for your window manager. (Alt + h)  

###OPENBOX :
`<keybind key="A-h"><action name="execute"><command>/home/umen/SyNc/Scripts/System/better_history/better_history.sh rofi</command></action></keybind>`

## Todo :
* better visual for long commands
* future usage of ~/.my_history_selection to sort by most used command, rather than last used commands
* improve unreliable regex for zsh history file (sed 's/.*:0;//')
* use "rofi" with options --rofi instead of argument
* usage of regular expressions
* use current shell, instead of default shell $SHELL
* support for more shells
* support help on dependancies for more distributions
* find the directory the command was run on, based on previous "cd" to recreate absolute path and/or test if target exist (file)
* after rofi selection, open a terminal and prepare to run the command (as well as absolute path)
* is it working if the user have customized history format ? if not, find solution

## Code explanations :
1. remove duplicates from the list : `awk '!x[$0]++'`
2. remove the "h" alias itself from the result : `sed '/^h /d'`
3. reverse the list, last commands stay top : `tac`
4. clean "zsh_history" nto plain text : `sed 's/.*:0;//'`
5. use `readlink` if for example "/bin/sh" is a link towards "/usr/bin/zsh"
