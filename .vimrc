let mapleader = "\<Space>"
" Autoinstall vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif
call plug#begin('~/.vim/plugged')
Plug 'klen/python-mode'
Plug 'vim-scripts/indentpython'
Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'
Plug 'valloric/youcompleteme'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'
Plug 'terryma/vim-multiple-cursors'
" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
call plug#end()
let g:fzf_commands_expect = 'alt-enter,ctrl-x'
let g:fzf_nvim_statusline = 0 " disable statusline overwriting
let g:fzf_action = {
  \ 'ctrl-m': 'tabedit',
  \ 'ctrl-o': 'e',
  \ 'ctrl-t': 'tabedit',
  \ 'ctrl-h':  'botright split',
  \ 'ctrl-v':  'vertical botright split' }

nnoremap <silent> <leader><space> :FZF<CR>
nnoremap <silent> <leader><enter> :FZF ~<CR>

let g:airline#extensions#tabline#formatter = 'default'
let base16colorspace=256
let g:airline_theme='wombat'

map <C-n> :NERDTreeToggle<CR>
map <C-o> :NERDTreeToggle %<CR>

filetype on
au FileType gitcommit set tw=72
set t_Co=16
set mouse=r
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$/
set noshowmode


set nofoldenable    " disable folding
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
set encoding=utf-8

let python_highlight_all=1
syntax on
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
noremap <Leader>Y "*y
noremap <Leader>P "*p
noremap <Leader>y "+y
noremap <Leader>p "+p
