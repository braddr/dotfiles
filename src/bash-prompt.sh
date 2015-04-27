#!/usr/bin/env bash

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    linux|screen|screen.linux|xterm-color|xterm-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    fi
fi

if [ -x $HOME/.git-prompt.sh ]; then
    . $HOME/.git-prompt.sh
    gitprompt=`__git_ps1 " (%s)"`
fi

curdir="${PWD/${HOME}/~}"

case "${curdir}" in
    \~/sandbox/dotfiles*)
        curdir="dotfiles${curdir/~\/sandbox\/dotfiles/}"
        ;;
    \~/sandbox/d/source/*)
        curdir="d${curdir/~\/sandbox\/d\/source\// }"
        ;;
    *)
        ;;
esac

if [ -r ~/.prompt-hostname ]; then
    h=`cat ~/.prompt-hostname`
else
    h="\h"
fi

if [ ! -z "$HOSTTYPE" ]; then
    h="$h ($HOSTTYPE)"
fi

function build_prompt() {
    if [ "$1" = "yes" ]; then
        c1="\[\e[01;32m\]"
        c2="\[\e[01;36m\]"
        cr="\[\e[00m\]"
    fi
    echo "${debian_chroot:+($debian_chroot)}${c1}\u@${h}${cr}:${c2}${curdir}${cr}${gitprompt}"
}

if [ -t 0 -a ! -z "$color_prompt" ]; then
    echo -n "\[\033]2;$(build_prompt)\]"
fi

echo -n "$(build_prompt $color_prompt)\$ "

