#!/usr/bin/env bash
# vim: fdm=marker foldmarker={{{,}}} foldlevel=1

# If not running interactively, don't do anything {{{
    [ -z "$PS1" ] && return
# }}}
# history {{{
    export HISTCONTROL=ignoredups:erasedups:ignorespace
    export HISTSIZE=5000
# }}}
# prompt {{{
    __prompt_command() {
        [ $? != 0 ] && echo -e "${TXTRED}\xE2\x98\xB9" # sad face
        dir=$(basename $(dirname $PWD))/$(basename $PWD) # display only 2 level dir
        PS1="\[\e[1;34m\]- \[\e[1;31m\]$dir >\[\e[1;33m\]>\[\e[1;32m\]> \[\e[0m\]"
    }

    PROMPT_COMMAND=__prompt_command
# }}}
# directory {{{
    alias ..='cd ..'
    alias ...='cd ../..'
    alias ....='cd ../../..'

    export LSCOLORS='Gxfxcxdxdxegedabagacad'
    alias ls='ls -hF --color=auto'
    alias l='ls -1'
    alias ll='ls -l'
    alias la='ls -la'
    alias lsall='ls -1d $(find .)'
# }}}
# git {{{
    alias gb='git branch'
    alias gbc='git checkout -b'
    alias gbx='git branch -d'
    alias gbX='git branch -D'
    alias gbm='git branch -m'
    alias gbM='git branch -M'
    alias gco='git checkout'

    function thisb {
        git rev-parse --abbrev-ref HEAD
    }

    function gpushbranch {
        git push origin `thisb`
    }

    alias gcm='git commit --message'
    alias gco='git checkout'
    alias gcpn='git cherry-pick --no-commit'
    alias gcp='git cherry-pick'
# }}}
# utils {{{
    export SHELL="bash"
    alias reload='exec $SHELL'

    if [ ! -x "$(which tree 2>/dev/null)" ]; then
        alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
    fi

    ips () {
        # determine local IP address
        ifconfig | grep "inet " | awk '{ print $2 }'
    }

    man () { # color man
        env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
    }

    extract () {
        if [ $# -ne 1 ]; then
            echo "Error: No file specified."
            return 1
        fi
        if [ -f $1 ]; then
            case $1 in
                *.tar.bz2) tar xvjf $1   ;;
                *.tar.gz)  tar xvzf $1   ;;
                *.bz2)     bunzip2 $1    ;;
                *.rar)     unrar x $1    ;;
                *.gz)      gunzip $1     ;;
                *.tar)     tar xvf $1    ;;
                *.tbz2)    tar xvjf $1   ;;
                *.tgz)     tar xvzf $1   ;;
                *.zip)     unzip $1      ;;
                *.Z)       uncompress $1 ;;
                *.7z)      7z x $1       ;;
                *)         echo "'$1' cannot be extracted via extract" ;;
            esac
        else
            echo "'$1' is not a valid file"
        fi
    }

# }}}
# mac {{{
    if [ `uname` = 'Darwin' ]; then
        alias ls='ls -GF'

        cdf () {
            target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
            if [ "$target" != "" ]; then
                cd "$target"; pwd
            else
                echo 'No Finder window found' >&2
            fi
        }

        alias showHidden='_hidden_files YES'
        alias hideHidden='_hidden_files NO'
        _hidden_files () {
            defaults write com.apple.finder AppleShowAllFiles $1
            killall Finder /System/Library/CoreServices/Finder.app
        }

    fi
# }}}
