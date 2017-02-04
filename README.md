# better_history.sh

This script give interactive access to the user's history with regex and a dialog list.

The user can then paste the wanted command using Ctrl + Shift + v

It is supposed to be use with an alias : alias h="/path/to/this/script"

It is supposed to be launched with a simple "h whatever"

- Use the default shell, based on $SHELL environment variable

## Todo :
* support for more shells
* usage of ~/.my_history_selection to sort by most used command, rather than last used commands
* improve unreliable regex (sed 's/.*:0;//')
* version with rofi ?
* use current shell, instead of default shel $SHELL

## Code explanations :
1 - remove duplicates from the list : awk '!x[$0]++'
2 - remove "h" command itself : sed '/^h /d'
3 - reverse the list, last commands stay top : tac
4 - clean zsh_history : sed 's/.*:0;//'
5 - use readlink if /bin/sh is a link towards /usr/bin/zsh
