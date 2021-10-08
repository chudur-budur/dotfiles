#!/bin/bash
# ~/.bash_aliases: executed by ~/.bashrc.
# This is a custom aliases set by '$USER'
# Put this file in '$HOME' (~/) folder

# this option is necessary to expand aliases
shopt -s expand_aliases

# hostname
hostname=$HOSTNAME ;

# osname and versions etc.
probe=$(ls /etc | grep release)
if [ ! -z "$probe" ]; then
    osstr=`cat /etc/*-release | head -n 1`
    if [[ $osstr = *"="* ]]; then
        osname=`echo $osstr | awk -F"=" '{print $2}'`
    else
        osname=`echo $osstr | awk -F" " '{print $1}'`
    fi
    # osname=`lsb_release -a | grep 'Distributor ID:' | awk -F " " '{print $3}'`
else
    # if the machine is running osx
    sw_vers >/dev/null 2>&1
    if [[ "$?" != "127" ]]; then
        name=$(sw_vers | head -n 1 | awk -F":" '{print $2}')
        name="$(echo -e "${name}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
        ver=$(sw_vers | tail -n +2 | head -n 1 | awk -F":" '{print $2}')
        ver="$(echo -e "${ver}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
        bver=$(sw_vers | tail -n 1 | awk -F":" '{print $2}')
        bver="$(echo -e "${bver}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
        osname="$name"
    fi
fi

# do this because sudo does not understand aliases
alias sudo='sudo '

# ------------------ job hunting aliases --------------------
#
alias cvpdf='evince '$HOME'/Dropbox/personal/resumes/simple/resume-kat-eng.pdf &'
alias cvtxt='gvim '$HOME'/Dropbox/personal/resumes/simple/resume-kat-eng.txt &'
alias cvcat='less '$HOME'/Dropbox/personal/resumes/simple/resume-kat-eng.txt'
alias cltxt='gvim '$HOME'/Dropbox/personal/jobapp/us/interns/2019/cl.txt &'
alias lsjob='gvim '$HOME'/Dropbox/personal/jobapp/us/interns/2019/list.txt &'
#
_internsupp()
{
	if [ -f /usr/local/bin/internsupp.py ]; then
		python3 /usr/local/bin/internsupp.py ;
	fi
}
alias internsupp='_internsupp'

# my todo list
alias todo='vi '$HOME'/Dropbox/personal/todo.txt'
# my due list
alias due='vi '$HOME'/Dropbox/personal/due.txt'
# my idea list
alias ideas='vi '$HOME'/Dropbox/personal/ideas.txt'
# my settings log
alias settings='gvim '$HOME'/Dropbox/personal/system-settings/ubuntu-post-installation-notes.txt &'
# edit all-info.txt
alias allinfo='vi '$HOME'/Dropbox/personal/all-info.txt'

# ------------------ basic aliases --------------------
#

# all handy ls stuffs
if [[ "$hostname" == "kopashamsu.local" ]]; then
    alias ls='ls -G'
    alias lsa='ls -alh -G'
    alias ll='ls -alF -G'
    alias la='ls -A -G'
    alias l='ls -CF -G'
else
    alias ls='ls --color=auto'
    alias lsa='ls -alh --color=auto'
    alias ll='ls -alF --color=auto'
    alias la='ls -A --color=auto'
    alias l='ls -CF --color=auto'
fi

# some handy disk usage commands
alias lfs='du -smh'
alias ldu='df -Th'
alias tree='tree -L 1 -h'

# current date/time
alias date='date +%Y-%m-%d.%H:%M'

# refresh locate database
if [[ "$osname" == "macOS" ]]; then
    if [ -d "/usr/local/opt/findutils/bin" ]; then
        alias updb='sudo /usr/local/opt/findutils/bin/gupdatedb'
        alias locate='/usr/local/opt/findutils/bin/glocate'
        alias find='/usr/local/opt/findutils/bin/gfind '
    fi
elif [ -x "$(command -v updatedb)" ]; then
    alias updb='sudo updatedb'
fi

# turn off machine
if [ -x "$(command -v shutdown)" ]; then
    alias off='sudo shutdown -h now'
fi
# restart machine
if [ -x "$(command -v reboot)" ]; then
    alias rbt='sudo reboot'
fi
# suspend
_suspend()
{
    if [ -x "$(command -v pmset)" ]; then
        pmset sleepnow
    elif [ -x "$(command -v systemctl)" ]; then
        systemctl suspend ;
    elif [ -x "$(command -v dbus-send)" ]; then
        dbus-send --type=method_call --dest=org.gnome.ScreenSaver \
            /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock \
            && dbus-send --system --print-reply --dest=org.freedesktop.UPower \
            /org/freedesktop/UPower org.freedesktop.UPower.Suspend
    else
        echo "Error: No suitable command found, please do it manually, thanks."
    fi
}
alias suspend='_suspend'

# lock screen
_lockscreen()
{
    if [ -x "$(command -v pmset)" ]; then
        pmset displaysleepnow
	elif [ -x "$(command -v dbus-send)" ]; then
		dbus-send --type=method_call --dest=org.gnome.ScreenSaver \
			/org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock
	else
		echo "Error: No suitable command found, please do it manually, thanks."
	fi
}
alias lockscr='_lockscreen >>/tmp/my-system-warnings.log 2>&1 &'
# alias lockscr='_lockscreen'

# refresh panel function
_refresh()
{
	# if gnome is running
	if [ -x "$(command -v dbus-send)" ]; then
		dbus-send --type=method_call --print-reply --dest=org.gnome.Shell \
			/org/gnome/Shell org.gnome.Shell.Eval string:'global.reexec_self()'
	# if Unity is running
	elif [ $(pgrep -c unity-panel-ser) -gt 0 ]; then
		sudo killall unity-panel-service
	else
		echo "Error: No suitable command found, please do it manually, thanks."
	fi
}
# refresh panel
alias refresh='_refresh >>/tmp/my-system-warnings.log 2>&1 &'

# safe rm commands
_rm()
{
    if [[ "$osname" == "macOS" ]]; then
        if [[ $@ == *'*'* ]]; then
            # lst=$(ls | grep "$@")
            lst=$(find . -maxdepth 1 -name "$@")
            for f in $lst
            do
                echo "mv $f $HOME/.Trash/"
            done
        else
            echo "mv $@ $HOME/.Trash/"
        fi
    else
        if ! [ -x "$(command -v gio)" ]; then
		    echo "Warning: GIO is not installed, using the standard rm."
            /bin/rm $@ ;
	    else
		    if [ "$1" = "*" ]; then
			    echo "Warning: DON'T DO THAT. If you are sure, use /bin/rm."
		    elif [[ $@ == *"-rf"* ]]; then
			    targets="${@//-rf}" ;
			    set +f ;
			    gio trash $targets ;
		    else
			    targets="${@//-rf}" ;
			    set +f ;
			    gio trash $@ ;
		    fi
	    fi
    fi
}
alias rm='set -f; _rm'

# purge command
_purge()
{
    if [ -d "$HOME/.local/share/Trash" ]; then
        trash="$HOME/.local/share/Trash/files"
        info="$HOME/.local/share/Trash/info"
    elif [ -d "$HOME/.Trash" ]; then
        trash="$HOME/.Trash"
        info=
    else
        echo "Error: can't find the trash folder. Please empty the trash manually."
    fi
    declare -a files=( $(ls -1 $trash) )
    declare -a infos=( $(ls -1 $info) )
    if [[ -z "$files" ]] && [[ -z "$infos" ]]; then
        echo "Trash is already empty." ;
    else
        if [ ! -z "$files" ]; then
            for f in "${files[@]}";
            do
                echo "/bin/rm -f $trash/$f" ;
                /bin/rm -rf "$trash/$f" ;
            done
        fi
        if [ ! -z "$infos" ]; then
            for f in "${infos[@]}";
            do
                echo "/bin/rm -f $info/$f" ;
                /bin/rm -rf "$info/$f" ;
            done
        fi
    fi
}
alias rm!='_purge'

_openuniversal()
{
    if [[ "$osname" == "macOS" ]]; then
        /usr/bin/open $@
    else
	    if [ -x "$(command -v xdg-open)" ]; then
            path="$@"
            if [ -z "$path" ]; then
                path="."
            fi
		    xdg-open $path >>/tmp/my-system-warnings.log 2>&1 &
	    else
		    echo "Error: xdg-open is not installed, open manually, thanks."
	    fi
    fi
}
alias open='_openuniversal'

# open xterm function
alias xtrm='xterm -u8 -e /bin/bash &'

# open terminal function
_openTerminal()
{
    if [ -f /usr/bin/open ]; then
        /usr/bin/open -a /System/Applications/Utilities/Terminal.app . &
	elif [ "$osname" = "Ubuntu" ]; then
		if [[ "$XDG_CURRENT_DESKTOP" == "Unity" ]] || [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
			gnome-terminal >>/tmp/my-system-warnings.log 2>&1 &
        elif [[ "$XDG_CURRENT_DESKTOP" == "XFCE" ]] || [[ "$XSESSION_EXEC" == *"xfce4"* ]]; then
            if [ -x "$(command -v xfce4-terminal)" ]; then
                xfce4-terminal >>/tmp/my-system-warnings.log 2>&1 &
            elif [ -x "$(command -v gnome-terminal)" ]; then
				gnome-terminal >>/tmp/my-system-warnings.log 2>&1 &
			else
				xterm &
			fi
	    else
		    if [ -x "$(command -v gnome-terminal)" ]; then
			    gnome-terminal >>/tmp/my-system-warnings.log 2>&1 &
		    else
			    xterm &
		    fi
		fi
	else
		if [ -x "$(command -v gnome-terminal)" ]; then
			gnome-terminal >>/tmp/my-system-warnings.log 2>&1 &
		else
			xterm &
		fi
	fi
}
alias trm='_openTerminal'


_killallTerminals()
{
    if [[ "$osname" == "macOS" ]]; then
        pkill -a Terminal
    else
		if [ -x "$(command -v gnome-terminal)" ]; then
	        killall -q gnome-terminal ;
        fi
		if [ -x "$(command -v xterm)" ]; then
	        killall -q xterm ;
        fi
    fi
}
alias trmq='_killallTerminals'

# clear screen
alias clr='clear'

# see the ubuntu version
if [[ "$osname" == "macOS" ]]; then
    alias osver='sw_vers'
else
    alias osver='lsb_release -a'
fi
# see the short version of the system info
alias osinfo='uname -a'

# a better csv file viewer
_csvcat()
{
	cat $@ | sed -e 's/,,/, ,/g' | column -s, -t | less -#5 -N -S ;
}
alias csvcat='_csvcat'

# kill all other users except me
_killallUsers()
{
    if [[ "$osname" == "macOS" ]]; then
        echo "Not implemented yet" ;
    else
        me=$USER ;
        allusrlst=`who | awk -F" " '{print $1}'`;
        readarray -t allusr <<<"$allusrlst" ;
        notme=();
        for (( i=0; i<${#allusr[@]}; i++ ))
        do
            if [ "${allusr[i]}" != "$me" ]; then
                notme+=("${allusr[i]}");
            fi
        done
        if [[ ${#notme} -gt 0 ]]; then
            echo "killing all except '$me'";
            for (( i=0; i<${#notme[@]}; i++ ))
            do
                # groups "${notme[i]}";
                echo "killing ${notme[i]}";
                sudo pkill -KILL -u "${notme[i]}"; 
            done
        else
            echo "no one to kill";
        fi
    fi
}
alias kau='_killallUsers'

# see which packages were manually installed
_manuallyinstalled()
{
	if [ -x "$(command -v apt-mark)" ]; then
        comm -23 <(apt-mark showmanual | sort -u) \
            <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)
    fi
}
alias manuallyinstalled='_manuallyinstalled'

# -------------------- app aliases --------------------

# gvim
alias gvm='gvim' # gv is ghostview
alias mvm='mvim' # gv is ghostview

# evince
alias ev='evince'

# code indentation commands using astyle
_stylec()
{
	# allman c style
	args=$@ ;
	if [[ ! $args =~ "-k" ]]; then
		astyle --style=allman --indent=tab $args ;
		echo "removing *.orig files ..." ;
		rm -rf *.*.orig ;
	else
		newargs=" $args " ;
		newargs=${newargs// -k / };
		astyle --style=allman --indent=tab $newargs ;
	fi
}
_stylesl() 
{
	# sean luke style
	args=$@ ;
	if [[ ! $args =~ "-k" ]]; then
		astyle --style=whitesmith --indent=spaces $args ;
		echo "removing *.orig files ..." ;
		rm -rf *.*.orig ;
	else
		newargs=" $args " ;
		newargs=${newargs// -k / };
		astyle --style=whitesmith --indent=spaces $newargs ;
	fi
}
_stylej()
{
	# java style
	args=$@ ;
	if [[ ! $args =~ "-k" ]]; then
		astyle --style=java --indent=tab $args ;
		echo "removing *.orig files ..." ;
		rm -rf *.*.orig ;
	else
		newargs=" $args " ;
		newargs=${newargs// -k / };
		astyle --style=java --indent=tab $newargs ;
	fi
}
_stylepy()
{
	# python autopep8 style
	args=$@ ;
	if [[ ! $args =~ "-k" ]]; then
		autopep8 --in-place $args ;
		echo "autopepping in-place ..." ;
	else
		newargs=" $args " ;
		newargs=${newargs// -k / };
		newargs="${newargs#"${newargs%%[![:space:]]*}"}"   # remove leading space
		newargs="${newargs%"${newargs##*[![:space:]]}"}"   # remove trailing space
		autopep8 $newargs > ${newargs}.orig ;
	fi
}
alias stylec='_stylec'
alias stylesl='_stylesl'
alias stylej='_stylej'
alias stylepy='_stylepy'

# the same problem with emacs 
alias emx='emacs'
alias em='emacs -nw'

# run SBCL, not using anymore, 
# sbcl is now installed on /usr/local/bin
# alias sbcl='run-sbcl.sh' 

# start bc with float arith
_startbc()
{
	host=$(hostname) ;
	if [[ $host == *"gateway"* ]] || [[ $host == *"eval"* ]]; then
		bc ;
	else
		xterm bc -l & 
	fi
}
alias bc='_startbc'

# opens TeXLive Manager
alias tlmgr='sudo /opt/texlive/2018/bin/x86_64-linux/tlmgr'

# opens tor browser
alias tbb=''$HOME'/tor-browser_en-US/start-tor-browser' ;

# opens QtCreator
alias qtcreator='sudo /opt/Qt5.2.1/Tools/QtCreator/bin/qtcreator'

# JabRef
alias jabref='java -jar /opt/JabRef-3.4.jar'

# git commands
alias gpull='git pull origin'
alias gls='git ls-files'
alias gadd='git add'
alias gci='git commit'
alias gpush='git push origin'
alias gco='git checkout'
alias grm='git rm --cached'
alias gmv='git mv'
alias gdiff='git diff'
alias gdiffn='git diff --name-only'
alias gtrack='git branch --track'
alias gstat='git status'
alias glg='git lg'
alias glg1='git lg1'
alias glg2='git lg2'
alias glg3='git lg3'
alias glg4='git lg4'
alias glg5='git lg5'
alias glg6='git lg6'
alias glog='git log'

# opening LaTeXDraw 
_openLatexDraw()
{
	ldfolder=`ls /opt | grep latexdraw` ;
	if [ -d "/opt/$ldfolder" ]; then
		java -jar /opt/$ldfolder/LaTeXDraw.jar &
	fi
}
alias ltdr='_openLatexDraw'

# opening matlab
_openMatlabNoDesktop()
{
	if [ -x "$(command -v matlab)" ]; then
		matlab -nodesktop -nosplash;
	fi
}
alias mlbcli='_openMatlabNoDesktop'
# open a barebone matlab in the terminal
_openMatlab()
{
	if [ -x "$(command -v matlab)" ]; then
		synclient HorizEdgeScroll=0 HorizTwoFingerScroll=0 &
		matlab &
	fi
}
alias mlb='_openMatlab' 

# python and pip from homebrew
alias py='python'
alias py3='python3'
# pipenv shell
alias penv='pipenv shell'
# run jupyter qtconsole
alias py3qt='export QT_API=pyqt5 && jupyter qtconsole &'
# run jupyter notebook
alias py3nb='jupyter notebook --browser=chromium &'

# Add private aliases
if [ -f "$HOME/.myinfo" ]; then
    source $HOME/.myinfo
fi

# this is the end of .bash_aliases
