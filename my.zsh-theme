#!/usr/bin/env zsh

# adapted from http://blog.ysmood.org/my-ys-terminal-theme/

# Machine name.
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname
}

# Directory info.
local current_dir=${PWD/#$HOME/~}

# Git info.
local git_info=$(git_prompt_info)
export ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[white]%}on%{$reset_color%} git:%{$fg[cyan]%}"
export ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
export ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}x"
export ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}o"

PROMPT="
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%{$fg[cyan]%}%n \
%{$fg[white]%}at \
%{$fg[green]%}$(box_name) \
%{$fg[white]%}in \
%{$fg[yellow]%}${current_dir}%{$reset_color%}\
${git_info} \
%{$fg[white]%}[%*]
%{$fg[yellow]%}$ %{$reset_color%}"

export LSCOLORS="gxfxcxdxbxegedabagacad"
