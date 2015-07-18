#!/usr/bin/env zsh


#### FOR SHELL STARTUP ####
warning-message () {
    printf "\n\t WARNING: %s \n" "$1"
    echo -n "Press [Enter] key to continue ..." && read
}
ensure-file () {
    [ -r "$1" ] || { warning-message "Unable to locate file, $1"; }
}
ensure-folder () {
    [ -d "$1" ] || { warning-message "Unable to locate folder, $1"; }
}
ensure-sym-link () {
    [ -h "$1" ] || { warning-message "Possible broken sym-link, $1"; }
    [ -s "$1" ] || { warning-message "Possible broken sym-link, $1"; }
}
#### ################# ####


f () {
    # look for file by name
    sudo find -x . -name "$1" -not -path "*/.MobileBackups/*" ;
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


# npm requires a number of files to be open, simultaneously
npm-init () {
    local msg="Is 'npm' installed? Hint: http://nodejs.org/download/"
    npm --version &> /dev/null || { echo "$msg" ; return ; }
}

npm-list () {
    npm-init
    npm list -g --depth=0;
}

npm-outdated () {
    npm-init
    npm outdated -g --depth=0;
}

npm-versions () {
    npm view "$1" versions
}


serve-local () {
    local msg="Is 'http-server' installed? Hint: \$ npm install http-server -g"
    http-server --help &> /dev/null || { echo "$msg" ; return ; }

    local host="localhost"
    local port="8000"
    [[ "$1" = "chrome" ]] && { open -a "/Applications/Google Chrome.app" "http://$host:$port/"; }
    http-server -p "$port" -a "$host"
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
