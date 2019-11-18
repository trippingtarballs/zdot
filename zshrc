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
#   zsh -i -c exit  0.10s user 0.06s system 88% cpu 0.180 total


# OH MY ZSH
# https://github.com/robbyrussell/oh-my-zsh#getting-updates (upgrade_oh_my_zsh)
export DISABLE_UPDATE_PROMPT=true
export DISABLE_AUTO_UPDATE=true
# https://github.com/robbyrussell/oh-my-zsh/pull/5694
export HISTSIZE=100000
export SAVEHIST=100000
# upgrade_oh_my_zsh

# load zgen
if [[ ! -e $HOME/Code/personal/zgen/zgen.zsh ]]
then
    printf "Unable to locate file: $HOME/Code/personal/zgen/zgen.zsh"
    return
else
    source $HOME/Code/personal/zgen/zgen.zsh
fi

# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # plugins
    # zgen oh-my-zsh plugins/aws
    zgen oh-my-zsh plugins/colored-man-pages
    zgen oh-my-zsh plugins/docker
    # zgen oh-my-zsh plugins/docker-compose
    zgen oh-my-zsh plugins/git
    # zgen oh-my-zsh plugins/gpg-agent
    # zgen oh-my-zsh plugins/nomad
    # zgen oh-my-zsh plugins/npm
    # zgen oh-my-zsh plugins/nvm
    # zgen oh-my-zsh plugins/pip
    # zgen oh-my-zsh plugins/virtualenvwrapper

    # zgen load lukechilds/zsh-better-npm-completion
    zgen load zsh-users/zsh-syntax-highlighting
    # zgen load trippingtarballs/zdot plugins/docker
    # zgen load trippingtarballs/zdot plugins/docker-compose
    # zgen load trippingtarballs/zdot plugins/docker-machine
    zgen load spwhitt/nix-zsh-completions

    # theme
    zgen load trippingtarballs/zdot themes/my

    # save all to init script
    zgen save
else
    # globals
    export ARCHFLAGS="-arch x86_64"
    export LANG=en_GB.UTF-8

    # A N D R O I D
    # export ANDROID_HOME=$HOME/Library/Android/sdk/
    # export JAVA_OPTS='-XX:+IgnoreUnrecognizedVMOptions --add-modules java.se.ee'
    # export JAVA_OPTS='-XX:+IgnoreUnrecognizedVMOptions --add-modules java.se.ee'`
    # F L U T T E R
    # export FLUTTER_HOME=/usr/local/share/flutter

    # B A T
    # https://github.com/sharkdp/bat#configuration-file
    export BAT_CONFIG_PATH=/Users/maverick/Code/personal/zdot/dots/bat.conf

    # G N U P R I V A C Y G U A R D
    # https://gist.github.com/bmhatfield/cc21ec0a3a2df963bffa3c1f884b676b
    if [ -n "$(pgrep gpg-agent)" ]; then
        export GPG_AGENT_INFO
    else
        eval $(gpg-agent --daemon --options $HOME/.gnupg/gpg-agent.conf)
    fi

    # G O L A N G
    # export GOPATH=$HOME/.golang
    # export GOROOT=/usr/local/opt/go/libexec
    # path=($path $GOPATH/bin $GOROOT/bin)

    # H O M E B R E W
    export HOMEBREW_NO_AUTO_UPDATE=1
    export HOMEBREW_GITHUB_API_TOKEN="<insert-key>"
    path=("${(@)path:#'/usr/local/bin'}")
    path=("${(@)path:#'/opt/X11/bin'}")
    path=(/usr/local/bin /usr/local/sbin $path)

    # H U B - https://hub.github.com
    export GITHUB_USER=trippingtarballs
    export GITHUB_TOKEN="<insert-key>"

    # O P A M (OCaml pkg manager)
    # source $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

    # load libraries
    source $HOME/Code/personal/zdot/alias.zsh
    source $HOME/Code/personal/zdot/devel.zsh
    source $HOME/Code/personal/zdot/funcs.zsh
fi

# EOF
