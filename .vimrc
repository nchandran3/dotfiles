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
" NOTE: Make sure to use single quotes!
   Plug 'Valloric/YouCompleteMe'
   Plug 'easymotion/vim-easymotion'
   Plug 'vim-syntastic/syntastic'
   Plug 'sheerun/vim-polyglot'
   Plug 'ctrlpvim/ctrlp.vim'
   Plug 'Quramy/tsuquyomi'
   Plug 'christoomey/vim-tmux-navigator'
   Plug 'dbeniamine/cheat.sh-vim'

call plug#end()


" Syntastic Plugin Options
set statusline+=%#warningmsg#
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" CtrlP Options
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = 'node_modules\|bower_components\|DS_Store\|git'


" ======================
" VIM Default Options
" ======================
filetype on
syntax on
colorscheme slate
set number " line numbers 
set showcmd " show partial commands as they are being typed
let mapleader=" "

" Tabs
set tabstop=2
set shiftwidth=2
set expandtab " use spaces instead of tabs.
set smarttab " lets tab key insert 'tab stops', and bksp deletes tabs.
set shiftround " tab / shifting moves to closest tabstop.
set autoindent " Match indents on new lines.
set smartindent " Intellegently dedent / indent new lines based on rules.

" Search options 
"set ignorecase " case insensitive search
"set smartcase " If there are uppercase letters, become case-sensitive.
"set showmatch " live match highlighting
"set incsearch " incremental search
"set hlsearch " highlight matches

" No need for this since we have Git
set nobackup
set nowritebackup
set noswapfile

" =================
" CUSTOM MAPPINGS
" =================

" EasyMotion Plugin
let g:EasyMotion_do_mapping = 0 " Disable default mappings
" Use easy motion for searching, which shows matches more visibly
map  / <Plug>(easymotion-sn)
" Clear match highlighting after doing a search
noremap <leader><space> :noh<cr>:call clearmatches()<cr>

" Use <space>+f and type two characters to jump anywhere on screen
nmap <Leader>f <Plug>(easymotion-overwin-f2)
"
" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1
"




" Can press jk in insert mode to escape out
inoremap jk <esc>

" bindings for easy split nav
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Visual line nav, not real line nav
" If you wrap lines, vim by default won't let you move down one line to the
" wrapped portion. This fixes that.
noremap j gj
noremap k gk
