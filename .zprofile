if [ -f /etc/profile ]; then
  source /etc/profile
fi
export PATH=$PATH:~/.local/bin:~/local/bin
export EDITOR='vim'
export CLICOLOR=true


setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt auto_param_slash
setopt list_types
setopt auto_menu
setopt auto_param_keys
setopt interactive_comments
setopt magic_equal_subst
setopt NO_LIST_BEEP
#setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
unsetopt extended_glob
unsetopt nomatch

zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'
zstyle ':completion:*' insert-tab pending
zstyle ':completion:*' rehash true
# zstyle ':completion:*' menu select=2

# add color
autoload colors
colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi;

plugin_src=~/.config/zsh/plugins.txt
plugin_sh=~/.config/zsh/plugins.sh
if [[ ! $plugin_sh -nt $plugin_src ]]; then
  antibody bundle < $plugin_src > $plugin_sh
fi
source $plugin_sh
unset plugin_src plugin_sh

# https://www.atlassian.com/git/tutorials/dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias rm='rm -v'
alias cp='cp -v'
alias mv='mv -v'
alias l='ls -lAh'

emulate sh
. ~/.sigopt-profile
emulate zsh

