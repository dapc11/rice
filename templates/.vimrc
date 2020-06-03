let mapleader =","

" Plugins, autoinstall vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif
call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mbbill/undotree'
Plug 'tpope/vim-commentary'
Plug 'valloric/youcompleteme'
Plug 'ap/vim-css-color'
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'
Plug 'chriskempson/base16-vim'
call plug#end()

set bg=dark
set go=a
set mouse=a
set nohlsearch
set clipboard+=unnamedplus

" Requires gvim
noremap <Leader>Y "*y
noremap <Leader>P "*p
noremap <Leader>y "+y
noremap <Leader>p "+p

" Some basics:
    nnoremap c "_c
    set hidden
    set noerrorbells
    set tabstop=4 softtabstop=4
    set shiftwidth=4
    set expandtab
    set smartindent
    set nu
    set nowrap
    set smartcase
    set noswapfile
    set nobackup
    set undodir=~/.vim/undodir
    set undofile
    set incsearch
    set nocompatible
    filetype plugin on
    syntax on
    set encoding=utf-8
    set number relativenumber
    let base16colorspace=256  " Access colors present in 256 colorspace
    set termguicolors

    set colorcolumn=80
    highlight ColorColumn ctermbg=0 guibg=lightgrey

    nnoremap <buffer> <silent> <leader>gd :YcmCompleter GoTo<CR>
    nnoremap <buffer> <silent> <leader>gr :YcmCompleter GoToReferences<CR>
    nmap <leader>q <plug>(YCMHover)
    let g:ycm_autoclose_preview_window_after_completion = 1
    let g:ycm_seed_identifiers_with_syntax = 1
    let g:ycm_collect_identifiers_from_tags_files = 1
    let g:ycm_key_invoke_completion = '<c-j>'
    let g:ycm_complete_in_strings = 1
    let g:ycm_key_list_stop_completion = ['<C-y>', '<CR>']

 "   let g:airline_theme='base16'
    colorscheme base16-oceanicnext
    colorscheme gruvbox

" Enable autocompletion:
    set wildmode=longest,list,full
" Disables automatic commenting on newline:
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Goyo plugin makes text more readable when writing prose:
    map <leader>f :Goyo \| set bg=light \| set linebreak<CR>

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
    set splitbelow splitright

" Nerd tree
    map <leader>r :NERDTreeFind<cr>
    map <leader>n :NERDTreeToggle<CR>
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Shortcutting split navigation, saving a keypress:
    map <C-h> <C-w>h
    map <C-j> <C-w>j
    map <C-k> <C-w>k
    map <C-l> <C-w>l

" Commenting
    map <C-_> gcc<CR>

" Replace ex mode with gq
    map Q gq

" Check file in shellcheck:
    map <leader>s :!clear && shellcheck %<CR>

" Replace all is aliased to S.
    nnoremap S :%s//g<Left><Left>

" Save file as sudo on files that require root permission
    cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Automatically deletes all trailing whitespace and newlines at end of file on save.
    autocmd BufWritePre * %s/\s\+$//e
    autocmd BufWritepre * %s/\n\+\%$//e

" When shortcut files are updated, renew bash and ranger configs with new material:
    autocmd BufWritePost files,directories !shortcuts

" fzf
    let g:fzf_nvim_statusline = 0 " disable statusline overwriting
    nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":FZF\<cr>"
    nnoremap <silent> <expr> <leader>f (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":FZF\<cr>"
    nnoremap <silent> <leader>a :Buffers<CR>
    nnoremap <silent> <leader>A :Windows<CR>
    nnoremap <silent> <leader>l :BLines<CR>
    nnoremap <silent> <leader>o :BTags<CR>
    nnoremap <silent> <leader>O :Tags<CR>
    nnoremap <silent> <leader>? :History<CR>

" UndoTree
    nnoremap <leader>u :UndotreeShow<CR>

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif


fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

fun! StartUp()
    if 0 == argc()
        NERDTree
    end
endfun

autocmd VimEnter * call StartUp()
autocmd BufWritePre * :call TrimWhitespace()
