#!/usr/bin/env zsh

f () {
    # look for file by name
    sudo find -x . -not -path "*/.MobileBackups/*" -not -path "*/node_modules/*" -not -path "*/private/*" -name "$1"
}
f-broken () {
    # look for broken symlinks
    sudo find -x . -type l -exec sh -c "file -b {} | grep -q ^broken" \; -print
}
f-symlink () {
    # look for all symlinks
    sudo find -x . -not -path "*/.MobileBackups/*" -type l
}

feed-me () {
    # list all alias, bins & funcs available, http://stackoverflow.com/a/948353
    (alias | cut -f1 -d= ; hash -f; hash -v | cut -f 1 -d= ; typeset +f) | sort
}

# usage:
#  $ egghead https://egghead.io/courses/functional-programming-concepts-in-purescript
egghead () {
    curl -sL "$1" \
    | grep -o -e 'https://[^"]*.m3u8' \
    | cat -n \
    | while read number file; do youtube-dl -o "$(printf "%02d" $number)-%(title)s.%(ext)s" $file; done
}

# `$ offline-site www.contentful.com/developers/docs/concepts`
offline-site () {
  wget \
    --recursive \
    --no-clobber \
    --page-requisites \
    --html-extension \
    --convert-links \
    --restrict-file-names=windows \
    --domains contentful.com \
    --no-parent "$1"
}


# "you know, for the times when you complete the internet and want to get more into it"
matrix () {
    echo -e "1";
    while $t; do
        for i in `seq 1 30`; do
            r="$[($RANDOM % 2)]";
            h="$[($RANDOM % 4)]";

            if [ $h -eq 1 ]; then
                v="0 $r";
            else
                v="1 $r";
            fi;

            v2="$v2 $v";
        done;
        echo -e $v2;v2="";
    done | GREP_COLOR="1;32" grep --color "[^ ]"
}


#### D O C K E R
# https://medium.com/the-code-review/clean-out-your-docker-images-containers-and-volumes-with-single-commands-b8e38253c271

# docker-daemon () {
#   launchctl list | grep "com.docker.docker" &> /dev/null;
#   if [ $? -ne 0 ]; then
#     echo "Is the docker daemon running?";
#     return 1;
#   else
#     return 0;
#   fi;
# }
# docker-clean-unused () {
#   local isDocker=$(docker-daemon);
#   [ "$isDocker" -eq 0] && docker system prune --all --force --volumes;
#   # [[ $(`docker-daemon`) == "0"]] && docker system prune --all --force --volumes;
# }
# docker-clean-all () {
#   if [ docker-daemon -eq 0]; then
#     docker container stop $(docker container ls -a -q);
#     docker-clean-unused;
#   fi;
# }

# # https://github.com/sharkdp/bat
# cat () {
#     BAT_CONFIG_PATH="/Users/maverick/Code/personal/zdot/dots/bat.conf" bat "$@"
# }


# http://ijoshsmith.com/2013/10/29/view-hidden-files-and-directories-with-finder-in-os-x-mavericks/
toggle-hidden-files () {
    local current=$(defaults read com.apple.finder AppleShowAllFiles)
    local new

    [[ "$current" == "YES" ]] && new="NO" || new="YES"

    defaults write com.apple.finder AppleShowAllFiles "$new"

    killall Finder
}

# defaults write com.apple.screencapture disable-shadow -bool false
toggle-drop-shadow () {
    local current=$(defaults read com.apple.screencapture disable-shadow)
    local new

    [[ "$current" == 1 ]] && new=0 || new=1

    defaults write com.apple.screencapture disable-shadow "$new"
}

# http://apple.stackexchange.com/a/212694
toggle-bezels-off () {
    launchctl unload -F /System/Library/LaunchAgents/com.apple.BezelUI.plist
}

# https://mac-how-to.gadgethacks.com/how-to/change-default-save-location-screenshots-mac-os-x-for-cleaner-desktop-0160154/
toggle-screenshot () {
    local prefered="$HOME/Screenshots"
    local standard="$HOME/Desktop"
    local selected=$(defaults read com.apple.screencapture location)

    local next
    [[ "$selected" == "$standard" ]] && next="$prefered" || next="$standard"

    defaults write com.apple.screencapture location "$next"

    killall SystemUIServer
}

# http://stackoverflow.com/a/19458175
remove-xattrs () {
    for file in "$@"
    do
        xattr "$file" | xargs -I {} xattr -d {} "$file"
    done
}

get-url () {
    curl -X GET $1 | jq .
}

# latest tagged version in repository https://stackoverflow.com/a/7261049
git-latest () {
    git describe --abbrev=0 --tags
}

# prune tags and re-sync with remote source
git-tag () {
    git tag -l | xargs git tag -d && git fetch -t
}

# git db cleanup of globs etc
git-clean () {
    rm -rf .git/gc.log && git gc --aggressive --prune=now && git fsck
}


# LOADERS
##########

# awsl () {
#     # A M A Z O N W E B S E R V I C E S
#     source /usr/local/share/zsh/site-functions/_aws
#     export AWS_PROFILE=${AWS_PROFILE:-"lesbose.dev"}
# }

gcloudl () {
    # G O O G L E C L O U D S D K
    source '~/.gcloud-sdk/path.zsh.inc'       # update PATH gcloud SDK
    path=(~/.gcloud-sdk/bin $path)
    source '~/.gcloud-sdk/completion.zsh.inc' # command completion
}

nixl () {
  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    # nix-env --switch-profile /nix/var/nix/profiles/per-user/maverick/profile
  fi
}

nvml () {
    # N O D E V E R S I O N M A N A G E R
    export NVM_DIR="$HOME/.nvm"
    source /usr/local/opt/nvm/nvm.sh "$@"
}

stackl () {
  # H A S K E L L (S T A C K)
  if type $HOME/.local/bin/stack &> /dev/null; then
    path=($path $HOME/.local/bin)
    autoload -U +X compinit && compinit
    autoload -U +X bashcompinit && bashcompinit
    eval "$(stack --bash-completion-script stack)"
  fi
}

terl () {
    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C terraform terraform
}

venvl () {
    # V I R T U A L E N V W R A P P E R

    #   1) pip3 install virtualenvwrapper
    #   2) ensure OH-MY-ZSH plugin is enabled
    #       3) export WORKON_HOME=$HOME/.env
    #       4) mkdir $WORKON_HOME
    #   5) export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
    #   6) `$ source /usr/local/bin/virtualenvwrapper.xsh`
    #   7) sym-link `postactivate` & `postdeactivate`

    # export WORKON_HOME="$HOME/.venv"

    # setup the correct path for `python3`
    # export PYTHON_EXEC="/usr/local/bin/python3"
    export VIRTUALENVWRAPPER_PYTHON="/usr/local/bin/python3"
    source /usr/local/bin/virtualenvwrapper.sh
}

# opaml () {
#     . $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
# }
