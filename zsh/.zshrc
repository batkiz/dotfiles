# theme
ZSH_THEME="ys"

if [ -e $HOME/.proxyrc ]; then
  . $HOME/.proxyrc
fi

export LC_CTYPE=zh_CN.UTF-8
export LANG="zh_CN.UTF-8"
export LC_ALL="zh_CN.UTF-8"

alias vim=nvim
alias docker=sudo docker
alias python=python3
alias pip=pip3
