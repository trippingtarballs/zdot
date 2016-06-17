#!/usr/bin/env zsh

f () {
    # look for file by name
    sudo find -x . -not -path "*/.MobileBackups/*" -name "$1"
}
f-broken () {
    # look for broken symlinks
    sudo find . -type l -exec sh -c "file -b {} | grep -q ^broken" \; -print
}
f-symlink () {
    # look for all symlinks in $HOME
    sudo find . -not -path "/.MobileBackups/*" -type l ;
}

feed-me () {
    # list all alias, bins & funcs available, http://stackoverflow.com/a/948353
    (alias | cut -f1 -d= ; hash -f; hash -v | cut -f 1 -d= ; typeset +f) | sort
}

# nvm loader
nvml () {
    export NVM_DIR=~/.nvm
    source ~/.nvm/nvm.sh
}

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

# http://stackoverflow.com/a/19458175
remove-xattrs () {
    for file in "$@"
    do
        xattr "$file" | xargs -I {} xattr -d {} "$file"
    done
}

# VS Code
code () {
    VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;
    export VSCODE_TSJS=1;
}
