set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl --insecure -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Automatically install missing plugins on startup
 if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
   autocmd VimEnter * PlugInstall | q
   endif
" My plugins
" NOTE: Make sure to use single quotes!
   Plug 'scrooloose/nerdtree' 

   Plug 'Valloric/YouCompleteMe'
   Plug 'sheerun/vim-polyglot'
   Plug 'w0rp/ale'

   Plug 'Quramy/tsuquyomi'

   Plug 'easymotion/vim-easymotion'
   Plug 'ctrlpvim/ctrlp.vim'
   Plug 'mileszs/ack.vim'
   Plug 'christoomey/vim-tmux-navigator'
   Plug 'dbeniamine/cheat.sh-vim'
   Plug 'tpope/vim-fugitive'

   Plug 'tpope/vim-abolish'
   
   Plug 'editorconfig/editorconfig-vim'

   Plug 'vim-airline/vim-airline'
   Plug 'vim-airline/vim-airline-themes'

call plug#end()

" ALE Options
let g:ale_sign_column_always = 1
let g:airline#extensions#ale#enabled = 1
let g:ale_set_highlights = 0
let g:ale_lint_delay = 1000


" NERDTree Options
map <C-o> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen = 1

" CtrlP Options
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = 'node_modules\|bower_components\|DS_Store\|git'

" Vim Airline Options
set term=screen-256color
set t_ut=
let g:airline_theme='minimalist'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_powerline_fonts = 1

" EasyMotion Plugin
let g:EasyMotion_do_mapping = 0 " Disable default mappings
" Use easy motion for searching, which shows matches more visibly
map  / <Plug>(easymotion-sn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
" Clear match highlighting after doing a search
noremap <leader><space> :noh<cr>:call clearmatches()<cr>
" Use <space>+f and type two characters to jump anywhere on screen
nmap <Leader>f <Plug>(easymotion-overwin-f2)
" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" Tsuquyomi Options
let g:tsuquyomi_definition_split = 3 " open definitions in new tab


" ======================
" VIM Default Options
" ======================
filetype on
syntax on
set encoding=utf-8
colorscheme slate
set number " line numbers 
set linebreak " don't wrap words in the middle
set showcmd " show partial commands as they are being typed
let mapleader=" "

" Change vim cursor on insert, replace, normal mode
let &t_SI.="\e[5 q"
let &t_SR.="\e[4 q"
let &t_EI.="\e[1 q"

" Tabs
set tabstop=2
set shiftwidth=2
set expandtab " use spaces instead of tabs.
set smarttab " lets tab key insert 'tab stops', and bksp deletes tabs.
set shiftround " tab / shifting moves to closest tabstop.
set autoindent " Match indents on new lines.
set smartindent " Intellegently dedent / indent new lines based on rules.

"Allow backspacing over autoindent, line breaks and
""start of insert action
set backspace=indent,eol,start

"Fast scrolling for long lines that cause redraw and buffer issues
set ttyfast

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
