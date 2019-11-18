#!/usr/bin/env zsh


# http://dave.cheney.net/2011/08/08/os-x-has-a-built-in-wifi-scanner ..... $ airport -s
alias airport=/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport

alias basher="env - /usr/local/bin/bash"

# http://bower.io/#uninstalling-packages
# alias bower="noglob bower"

alias g="grep -H --color"

# alias l="ls -lAh"
alias l="exa --all --long --group-directories-first --group --header"
alias lo="exa --all --long --group-directories-first --group --header --sort newest"

# https://wiki.videolan.org/Mac_OS_X/#Command_line
alias vlc="/Applications/VLC.app/Contents/MacOS/VLC"

alias zsh-time="time zsh -i -c exit"

alias yt="youtube-dl --format mp4"
alias yti="youtube-dl --ignore-errors --format mp4 --output \"%(autonumber)s-%(title)s.%(ext)s\""
alias yta="yt --extract-audio --audio-quality 0"

# npm related ...
alias npmi="npm install --ignore-scripts"
alias npmDD="npm install --save-dev --save-exact --no-shrinkwrap"
alias npmsd="npm install --save-exact --no-shrinkwrap --save-dev"
alias npmss="npm install --save-exact --no-shrinkwrap --save"
alias npxu="npx npm-check-updates"
# ncu --filter "/^(?\!webpack).+/"

# git related ...
alias gbv="gb -vv"
alias gbdd="gb -D"
alias ggpu="gp -u"
alias gl="git pull --ff-only" # override the default
# alias gtss="git tag | tail -1"
alias gtss="git log --tags --decorate --simplify-by-decoration --oneline"
# alias gbd="gbv --no-color | awk '/: gone]/{print $1}' | xargs git branch -D"


# https://medium.com/the-code-review/clean-out-your-docker-images-containers-and-volumes-with-single-commands-b8e38253c271
alias docker-clean-unused='docker system prune --all --force --volumes'
alias docker-clean-all='docker container stop $(docker container ls -a -q) && docker-clean-unused'


# https://github.com/sharkdp/bat
alias cat='bat'
