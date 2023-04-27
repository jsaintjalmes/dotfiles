" VUNDLE PLUGINS MANAGEMENT

set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" plugins listed here, in vim use the command :PluginInstall
Plugin 'VundleVim/Vundle.vim'
Plugin 'preservim/nerdtree'
Plugin 'preservim/nerdcommenter'

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
set softtabstop=2

" MAPPING

let mapleader =' '
map <C-n> :NERDTreeToggle<CR>

" THEME

Bundle 'sonph/onehalf', {'rtp': 'vim/'}
colorscheme onehalfdark
let g:airline_theme='onehalfdark'
