" VUNDLE PLUGINS MANAGEMENT

set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'preservim/nerdtree'
Plugin 'preservim/nerdcommenter'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'rhysd/vim-clang-format'

" all plugins must be added before the following line
call vundle#end()
filetype plugin indent on

" CONFIG

set mouse=a
syntax on
set number
set showmatch

" TABS

set tabstop=2
set shiftwidth=2
set softtabstop=2

" MAPPING

" nerdcommenter:
let mapleader =' '
# nerdtree:
map <C-n> :NERDTreeToggle<CR>

" tmux
let g:tmux_navigator_no_mappings = 1

" matching keybindings
noremap <silent> <C-h> :<C-U>TmuxNavigateLeft<cr>
noremap <silent> <C-k> :<C-U>TmuxNavigateDown<cr>
noremap <silent> <C-j> :<C-U>TmuxNavigateUp<cr>
noremap <silent> <C-l> :<C-U>TmuxNavigateRight<cr>
noremap <silent> <C-P> :<C-U>TmuxNavigatePrevious<cr>

" THEME

Bundle 'sonph/onehalf', {'rtp': 'vim/'}
colorscheme onehalfdark
let g:airline_theme='onehalfdark'
