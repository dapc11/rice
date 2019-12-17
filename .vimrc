let mapleader = "\<Space>"
" Autoinstall vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif
call plug#begin('~/.vim/plugged')
Plug 'klen/python-mode'
Plug 'valloric/youcompleteme'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
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

let g:ycm_python_interpreter_path = '~/anaconda3/bin/python'
let g:ycm_python_sys_path = []
let g:ycm_extra_conf_vim_data = [
  \  'g:ycm_python_interpreter_path',
  \  'g:ycm_python_sys_path'
  \]
let g:ycm_global_ycm_extra_conf = '~/global_extra_conf.py'
let g:airline#extensions#tabline#formatter = 'default'
set background=dark
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
