#!/bin/zsh

autoload -U compinit && compinit # tab completions
autoload -U promptinit && promptinit # prompts

# directory options
setopt autocd        # change directory without "cd"
setopt autopushd     # make cd work like pushd

unsetopt beep        # don't beep!
setopt correctall    # command correction
setopt extendedglob  # extended globbing, eg. `cp ^*.(tar`

setopt appendhistory # append history to history file instead of replacing

# completion to include menu selection, case insensitive and match in words
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{[:lower][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|='

# keyboard shortcuts
bindkey -e # emacs mode

# export variables to make emacs OK. TODO: move this to emacs app
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM=xterm-256color
