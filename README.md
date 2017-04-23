# ٩(̾●̮̮̃̾•̃̾)۶ better_history.sh

This script gives a friendlier access CLI or GUI (with `rofi`) to the user's shell history.  

The user can select a previous command and it will be put in the clipboard's buffer using `xclip`.  
The user can then paste the command using Ctrl + Shift + v in the terminal. (Or use the `rofi` options to automatically run it)  

Especially useful when you try to recover a long command you used a long time ago.

This script do not change the history file and should work in all situations. Or a least will.  

##CLI : Command Line Interface - h

From a terminal emulator, it is supposed to be launched with a simple "h what_ever_you_want"  
Thanks to an alias : `alias h="/path/to/this/script"` (in ".bashrc" file, ".zshrc",  etc...)

If you remember that the command contain the word "debug", you can use "h debug" to find it back quickly.

Works better with a big history record :  
`export HISTSIZE=10000` (in ".bashrc" file, ".zshrc",  etc...)

##GUI : Graphical User Interface - Rofi
Use `rofi` interface with a shortcut for your window manager. (Alt + h)  

###sxhkd ("sxhkdrc") : shortcut daemon for all window managers
`alt + h`  
&nbsp;&nbsp;&nbsp;&nbsp;`/home/umen/SyNc/Scripts/System/better_history/better_history.sh rofi`


###openbox only ("rc.xml") :
`<keybind key="A-h">`  
&nbsp;`<action name="execute">`  
&nbsp;&nbsp;`<command>/home/umen/SyNc/Scripts/System/better_history/better_history.sh rofi</command>`  
&nbsp;`</action>`  
`</keybind>`

## Todo :
* Try to find the directory the command was run on. Maybe based on previous "cd" to recreate absolute path and/or test if target exist (file) __without changing history file syntax__
* better visual for long commands
* support for more shells
* support help on dependancies for more distributions
* future usage of `~/.my_history_selection` to sort by most used command, instead of last used commands
* improve unreliable regex for zsh history file `(sed 's/.*:0;//')`
* use `rofi` with options `--rofi` instead of argument
* use current shell, instead of default shell `$SHELL`
* is it working if the user have customized history format ? if not, find solution
* Bug with selection with "Binary file (standard input)" match ???
...

## Not Todo (excluded on purpose, stay simple and portable)
* modify the history file in any way to "add useful informations"
* usage of regular expressions in search
