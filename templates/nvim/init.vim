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

autocmd BufReadPost,BufNewFile * :call HighlightTodo()
autocmd BufWritePre * :call TrimWhitespace()
" Automatically deletes all trailing whitespace and newlines at end of file on save
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritepre * %s/\n\+\%$//e

lua require("dapc")
lua require'nvim-treesitter.configs'.setup { highlight = { enable = true }, incremental_selection = { enable = true }, textobjects = { enable = true }}
