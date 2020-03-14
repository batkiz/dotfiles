# theme
ZSH_THEME="ys"

# wsl 2
# export hostip=$(cat /etc/resolv.conf |grep -oP '(?<=nameserver\ ).*')
# wsl 1 - default
export hostip="127.0.0.1"
alias socks="http_proxy=http://${hostip}:43333 https_proxy=http://${hostip}:43333" 

export LC_CTYPE=zh_CN.UTF-8
export LANG="zh_CN.UTF-8"
export LC_ALL="zh_CN.UTF-8"

alias vim=nvim
alias python=python3
alias pip=pip3