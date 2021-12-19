set path+=**
nnoremap <SPACE> <Nop>
let mapleader =" "

runtime plugins.vim
set background=dark
colorscheme dapc11

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
require("options")
require("lsp_config")
require("keymaps")
require("fzf")
EOF

" Python
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

highlight! CmpItemAbbrMatch guibg=NONE guifg={{base0D}}
highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg={{base0D}}
highlight! CmpItemKindFunction guibg=NONE guifg={{base0E}}
highlight! CmpItemKindMethod guibg=NONE guifg={{base0E}}
highlight! CmpItemKindVariable guibg=NONE guifg={{base0C}}
highlight! CmpItemKindKeyword guibg=NONE guifg={{base07}}
