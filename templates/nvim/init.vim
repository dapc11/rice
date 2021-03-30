nnoremap <SPACE> <Nop>
let mapleader =" "

so ~/.config/nvim/plugins.vim
set background=dark
so ~/.config/nvim/dapc11.vim
"colorscheme gruvbox
so ~/.config/nvim/options.vim
so ~/.config/nvim/statusline.vim
so ~/.config/nvim/mappings.vim
so ~/.config/nvim/fzf.vim

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
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" Automatically deletes all trailing whitespace and newlines at end of file on sav
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritepre * %s/\n\+\%$//e
