#!/usr/bin/env zsh


# NOTES:
#   $ zgen update && zgen reset
#   $ zsh-time
#   zsh -i -c exit  0.15s user 0.11s system 97% cpu 0.276 total


# load zgen
source ~/Code/opensrc/zgen/zgen.zsh

# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # plugins
    # zgen oh-my-zsh plugins/colored-man
    zgen oh-my-zsh plugins/docker
    # zgen oh-my-zsh plugins/docker-compose
    # zgen oh-my-zsh plugins/nvm
    # zgen oh-my-zsh plugins/pip
    # zgen oh-my-zsh plugins/virtualenvwrapper

    zgen load zsh-users/zsh-syntax-highlighting

    # theme
    zgen load rbose85/zdot my

    # save all to init script
    zgen save
else
    # H O M E B R E W
    path=("${(@)path:#'/usr/local/bin'}")
    path=("${(@)path:#'/opt/X11/bin'}")
    path=(/usr/local/bin /usr/local/sbin $path)

    # globals
    export ARCHFLAGS="-arch x86_64"
    export LANG=en_GB.UTF-8

    # A N D R O I D
    export ANDROID_HOME=/usr/local/opt/android-sdk

    # G O L A N G
    export GOPATH=$HOME/.golang
    export GOROOT=$(brew --prefix golang)/libexec
    path=($path $GOPATH/bin $GOROOT/bin)

    # load libraries
    source ~/Code/personal/zdot/alias.zsh
    source ~/Code/personal/zdot/funcs.zsh
    source ~/Code/personal/zdot/devel.zsh
fi

# EOF
