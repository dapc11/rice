nnoremap <SPACE> <Nop>
let mapleader =" "

so ~/.config/vim/plugins.vim
so ~/.config/vim/dapc11.vim
set background={{vim_theme}}
so ~/.config/vim/statusline.vim
so ~/.config/vim/mappings.vim
so ~/.config/vim/fzf.vim
so ~/.config/vim/options.vim

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
