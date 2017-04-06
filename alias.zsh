#!/usr/bin/env zsh


# http://dave.cheney.net/2011/08/08/os-x-has-a-built-in-wifi-scanner ..... $ airport -s
alias airport=/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport

alias basher="env - /usr/local/bin/bash"

# http://bower.io/#uninstalling-packages
# alias bower="noglob bower"

alias g="grep -H --color"

alias l="ls -lAh"

# https://wiki.videolan.org/Mac_OS_X/#Command_line
alias vlc="/Applications/VLC.app/Contents/MacOS/VLC"

alias zsh-time="time zsh -i -c exit"

alias yt="youtube-dl --format mp4"
alias yta="yt --extract-audio --audio-quality 0"
