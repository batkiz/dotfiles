# dotfiles

_a collection of my dotfiles._

including: neovim, powershell, zsh, git, etc.

## nvim

1. 安装 neovim，安装 [vim-plug](https://github.com/junegunn/vim-plug/)
2. 将 `init.vim` 置于 `~/.config/nvim/`
3. 进入 nvim，执行 `:PlugInstall`

thanks to [k-vim](https://github.com/wklken/k-vim), [森林](https://www.liuhaolin.com/vim/341.html)。

## pwsh

将该文件夹下的文件放在 `$PROFILE` 所在文件夹里。相关的依赖与更改请看代码的注释。

包含了自定义的主题 `ys`。

## zshrc

`socks` 用以使命令行临时走代理。

## git

仅包含部分个人配置（username, email）及代理设置。

## vscode

见此 [gist](https://gist.github.com/batkiz/0e17a875b6a22ec320f07e420ad3ee1a)

## wt

windows terminal

## scripts

随意写的一些小脚本。

- `GBK2UNICODE.csx`，用于将某文件夹下的所有文件从GBK编码转换到UNICODE（UTF-8）。
- `gifsplit.py`，用于分离gif图片的所有帧。
- `loopback.ps1`，用于开启windows的local loopback。
