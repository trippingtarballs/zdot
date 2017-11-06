#!/usr/bin/env zsh

# NOTES:
#
#   $ zsh -xv       # think about
#
#   $ zgen update && zgen reset
#   $ zsh-time
#   zsh -i -c exit  0.04s user 0.04s system 95% cpu 0.075 total # default
#   zsh -i -c exit  0.36s user 0.21s system 98% cpu 0.585 total
#   zsh -i -c exit  0.12s user 0.12s system 91% cpu 0.267 total # with nvm
#   zsh -i -c exit  0.12s user 0.10s system 95% cpu 0.237 total # without nvm
#   zsh -i -c exit  0.13s user 0.11s system 93% cpu 0.256 total # with opam


# OH MY ZSH
# https://github.com/robbyrussell/oh-my-zsh#getting-updates (upgrade_oh_my_zsh)
export DISABLE_UPDATE_PROMPT=true
export DISABLE_AUTO_UPDATE=true
# https://github.com/robbyrussell/oh-my-zsh/pull/5694
export HISTSIZE=100000
export SAVEHIST=100000
# upgrade_oh_my_zsh

# load zgen
source ~/Code/opensrc/zgen/zgen.zsh

# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # plugins
    zgen oh-my-zsh plugins/colored-man-pages
    # zgen oh-my-zsh plugins/docker
    # zgen oh-my-zsh plugins/docker-compose
    zgen oh-my-zsh plugins/git
    # zgen oh-my-zsh plugins/nvm
    # zgen oh-my-zsh plugins/pip
    # zgen oh-my-zsh plugins/virtualenvwrapper

    # zgen load lukechilds/zsh-better-npm-completion
    zgen load zsh-users/zsh-syntax-highlighting
    # zgen load trippingtarballs/zdot plugins/docker
    # zgen load trippingtarballs/zdot plugins/docker-compose
    # zgen load trippingtarballs/zdot plugins/docker-machine

    # theme
    zgen load trippingtarballs/zdot themes/my

    # save all to init script
    zgen save
else
    # globals
    export ARCHFLAGS="-arch x86_64"
    export LANG=en_GB.UTF-8

    # H U B - https://hub.github.com
    export GITHUB_USER=trippingtarballs
    export GITHUB_TOKEN="<insert-key>"

    # H O M E B R E W
    path=("${(@)path:#'/usr/local/bin'}")
    path=("${(@)path:#'/opt/X11/bin'}")
    path=(/usr/local/bin /usr/local/sbin $path)
    export HOMEBREW_GITHUB_API_TOKEN="<insert-key>"

    # N O D E V E R S I O N M A N A G E R
    export NVM_DIR="$HOME/.nvm"
    alias nvml=". /usr/local/opt/nvm/nvm.sh"

    # A N D R O I D
    export ANDROID_HOME=/usr/local/opt/android-sdk

    # G O L A N G
    # export GOPATH=$HOME/.golang
    # export GOROOT=/usr/local/opt/go/libexec
    # path=($path $GOPATH/bin $GOROOT/bin)

    # H A S K E L L
    path=($path $HOME/.local/bin)

    # O P A M (OCaml pkg manager)
    # source ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

    # load libraries
    source ~/Code/personal/zdot/alias.zsh
    source ~/Code/personal/zdot/devel.zsh
    source ~/Code/personal/zdot/funcs.zsh
fi

# EOF
