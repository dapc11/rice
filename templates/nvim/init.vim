set path+=**
nnoremap <SPACE> <Nop>
let mapleader =" "

runtime plugins.vim
set background=dark
colorscheme dapc11
runtime options.vim
runtime statusline.vim
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


set completeopt=menu,menuone,noselect
lua << EOF
require("lsp_config")
EOF
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
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
    " Yaml
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
    " autocmd BufRead * lua require('lint').try_lint()
    " autocmd BufWrite * lua require('lint').try_lint()
    autocmd BufReadPost,BufNewFile * :call HighlightTodo()
    autocmd BufWritePre * :call TrimWhitespace()
augroup END

function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

nnoremap <silent> <leader>cl :lua require('lint').try_lint()<cr>
