" 基础设置
" 开启语法高亮
syntax on

" for coc.vim
set hidden

set background=dark
set t_Co=256

" 检测文件类型
filetype on
" 针对不同的文件类型采用不同的缩进格式
filetype indent on
" 允许插件
filetype plugin on
" 启动自动补全
filetype plugin indent on
" 文件修改之后自动载入
set autoread

" 帮助语言为中文
set helplang=cn
" 设置新文件的编码为 UTF-8
set encoding=utf-8

" 取消备份
set nobackup
" 关闭交换文件
set noswapfile

" 突出显示当前行
set cursorline
" 突出显示当前列
" set cursorcolumn

" 最大历史数
set history=100

" 改变终端标题
set title

" For regular expressions turn magic on
set magic

" 显示当前的行号列号
set ruler
" 在状态栏显示正在输入的命令
set showcmd
" 左下角显示当前vim模式
set showmode

" 显示行号
set number
" 取消换行
set nowrap

" 括号配对情况, 跳转并高亮一下匹配的括号
set showmatch

" 高亮search命中的文本
set hlsearch
" 打开增量搜索模式,随着键入即时搜索
set incsearch
" 搜索时忽略大小写
set ignorecase
" 有一个或以上大写字母时仍大小写敏感
set smartcase

" Smart indent
set smartindent
" 打开自动缩进
set autoindent

" 设置Tab键的宽度        [等同的空格个数]
set tabstop=4
" 每一次缩进对应的空格数
set shiftwidth=4
" 按退格键时可以一次删掉 4 个空格
set softtabstop=4
" insert tabs on the start of a line according to shiftwidth, not tabstop 按退格键时可以一次删掉 4 个空格
set smarttab
" 将Tab自动转化成空格[需要输入真正的Tab键时，使用 Ctrl+V + Tab]
set expandtab



" 按键设置
let mapleader=','

" 用于快速进入命令行
nnoremap ; :

nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

" Go to home and end using capitalized directions
noremap H ^
noremap L $

" 搜索相关
" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
" 进入搜索Use sane regexes"
nnoremap / /\v
vnoremap / /\v

" kj 替换 Esc
inoremap kj <Esc>

" remap U to <C-r> for easier redo
nnoremap U <C-r>

" Quickly close the current window
nnoremap <leader>q :q<CR>
" Quickly save the current file
nnoremap <leader>w :w<CR>

" save
cmap w!! w !sudo tee >/dev/null %



" 插件
call plug#begin('~/.local/share/nvim/plugged')

" lightline
Plug 'itchyny/lightline.vim'

" one-dark theme
Plug 'joshdick/onedark.vim'

" syntax
Plug 'sheerun/vim-polyglot'

" rainbow brackets
Plug 'luochen1990/rainbow'

" auto pair
Plug 'jiangmiao/auto-pairs'

" 自动补全字典
Plug 'batkiz/vim-dictionary'

call plug#end()

" lightline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

" onedark
colorscheme onedark

" polyglot
" let g:polyglot_disabled = ['md']

" rainbow
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

" autopairs
let g:AutoPairsFlyMode = 1

" auto complete
set complete-=k complete+=k
function! InserTabWrapper()
        let col=col('.')-1
        if !col || getline('.')[col-1] !~ '\k'
                return "\<TAB>"
        else
                return "\<C-N>"
        endif
endfunction
inoremap <TAB> <C-R>=InserTabWrapper()<CR>
" 去除下面提示的匹配信息
set shortmess+=c