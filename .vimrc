set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Automatically install missing plugins on startup
 if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
   autocmd VimEnter * PlugInstall | q
   endif

" My plugins
   Plug 'vim-syntastic/syntastic'
   Plug 'ctrlpvim/ctrlp.vim'

call plug#end()


" Syntastic Plugin Options
set statusline+=%#warningmsg#
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" CtrlP Plugin Options
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'

" ======================
" VIM Default Options
" ======================
filetype on
syntax on
colorscheme slate
set number " line numbers 
let mapleader=" "

" Tabs
set tabstop=2
set shiftwidth=2
set expandtab " use spaces instead of tabs.
set smarttab " let's tab key insert 'tab stops', and bksp deletes tabs.
set shiftround " tab / shifting moves to closest tabstop.
set autoindent " Match indents on new lines.
set smartindent " Intellegently dedent / indent new lines based on rules.

" Search options 
set ignorecase " case insensitive search
set smartcase " If there are uppercase letters, become case-sensitive.
set showmatch " live match highlighting
set incsearch " incremental search
set hlsearch " highlight matches

" No need for this since we have Git
set nobackup
set nowritebackup
set noswapfile

" =================
" CUSTOM MAPPINGS
" =================

" Clear match highlighting
noremap <leader><space> :noh<cr>:call clearmatches()<cr>


" Can press jk in insert mode to escape out
inoremap jk <esc>

" Visual line nav, not real line nav
" If you wrap lines, vim by default won't let you move down one line to the
" wrapped portion. This fixes that.
noremap j gj
noremap k gk