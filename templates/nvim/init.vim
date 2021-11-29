set path+=**
nnoremap <SPACE> <Nop>
let mapleader =" "

runtime plugins.vim
set background=dark
colorscheme dapc11
syn region Comment start=/"""/ end=/"""/
" runtime statusline.vim
runtime mappings.vim
runtime fzf.vim

function! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

function! HighlightTodo()
    match none
    match Error /TODO/
endfunc

lua << EOF
vim.g.did_load_filetypes = 1
require("options")
require("lsp_config")
require("keymaps")
EOF
" Python
" au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \| set softtabstop=4
    \| set shiftwidth=4
    \| set textwidth=99
    \| set expandtab
    \| set autoindent
    \| set fileformat=unix

augroup dapc
    autocmd!
    au BufNewFile,BufRead *.py
        \ set tabstop=4
        \ set softtabstop=4
        \ set shiftwidth=4
        \ set textwidth=79
        \ set expandtab
        \ set autoindent
        \ set fileformat=unix
    " Yaml
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
    " autocmd BufRead * lua require('lint').try_lint()
    " autocmd BufWrite * lua require('lint').try_lint()
    autocmd BufReadPost,BufNewFile * :call HighlightTodo()
    autocmd BufWritePre * :call TrimWhitespace()
augroup END

au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=250, on_visual=true}
au TermOpen * setlocal nonumber norelativenumber
augroup neovim_terminal
    autocmd!
    " Enter Terminal-mode (insert) automatically
    autocmd TermOpen * startinsert
    " Disables number lines on terminal buffers
    autocmd TermOpen * :set nonumber norelativenumber
    " allows you to use Ctrl-c on terminal window
    autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c>
augroup END
