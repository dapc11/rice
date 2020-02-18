let mapleader = "\<Space>"  " make <space> be the leader key

" Plugins, autoinstall vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif
call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdcommenter'          " Comment multiline
Plug 'jiangmiao/auto-pairs'             " Auto pair (), {}, [], ''
Plug 'scrooloose/nerdtree'              " Nerdtree, explore files
Plug 'airblade/vim-gitgutter'           " Show modified lines in git repos
Plug 'vim-airline/vim-airline'          " Statusline
Plug 'vim-airline/vim-airline-themes'   " Statusline themes
Plug 'terryma/vim-multiple-cursors'     " Multiline editing, ctrl+n and i for insert
Plug 'yuttie/comfortable-motion.vim'    " Comfortable scrolling (scroll with Ctrl + d/u)
" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Fuzzyfinder, space+f and find away!
Plug 'junegunn/fzf.vim'
call plug#end()

" Fuzzyfind
let g:fzf_nvim_statusline = 0 " disable statusline overwriting
let g:fzf_action = { 'enter': 'e', 'ctrl-t': 'tabedit' }
nnoremap <silent> <expr> <Leader>f (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":FZF\<cr>"

filetype on
au FileType gitcommit set tw=72
set mouse=r
filetype plugin indent on
set tabstop=4       " show existing tab with 4 spaces width
set shiftwidth=4    " when indenting with '>', use 4 spaces width
set expandtab       " On pressing tab, insert 4 spaces
highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$/
set nofoldenable    " disable folding

" Movement
" ctrl + W = jump to next window
" ctrl + H = left
" ctrl + J = Down
" ctrl + K = Up
" ctrl + L = Right
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Copy to clipboard, requires vim-gtk
noremap <Leader>Y "*y
noremap <Leader>P "*p
noremap <Leader>y "+y
noremap <Leader>p "+p

" NERDTree
map <C-t> :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif " Open nerdtree if vim is opened without file

" Python syntax
au BufNewFile, BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix
au BufRead, BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

au BufNewFile, BufRead *.js, *.html, *.css, *.json, *.yaml
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

set encoding=utf-8

let python_highlight_all=1

set noshowmode " Disable mode showage

"""""""""""""""""" THEME
colorscheme base16-eighties
let g:airline_theme='base16_ocean'
set background=dark
highlight Visual cterm=NONE ctermbg=235 ctermfg=NONE guibg=NONE
