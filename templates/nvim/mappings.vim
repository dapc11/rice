nnoremap <SPACE> <Nop>
let mapleader =" "

map ä <C-d>
map ö <C-u>
map ga <Nop>
map ¨ <C-^>

inoremap <C-Space> <C-x><C-n>
nnoremap <silent> <A-left> :bp<CR>
nnoremap <silent> <A-right> :bn<CR>

" Requires gvim
" paste with shift+insert
noremap <Leader>Y "*y<CR>
noremap <Leader>P "*p<CR>
" paste with ctrl+v
noremap <Leader>y "+y<CR>
noremap <Leader>p "+p<CR>

" Close buffer
nnoremap <Leader>q <c-w>q<CR>
nnoremap <Leader>Q :qa<CR>

" Commandline
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <M-Left> <S-Left>
cnoremap <M-Right> <S-Right>
cnoremap <M-BS> <C-W>
cnoremap <C-BS> <C-W>

" Paste over select and keep register
vnoremap <leader>p "_dP

" :e sane mappings
set wildcharm=<C-Z>
cnoremap <expr> <up> wildmenumode() ? "\<left>" : "\<up>"
cnoremap <expr> <down> wildmenumode() ? "\<right>" : "\<down>"
cnoremap <expr> <left> wildmenumode() ? "\<up>" : "\<left>"
cnoremap <expr> <right> wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"

" Navigate errors
nnoremap <C-n> :cn<CR>
nnoremap <C-b> :cp<CR>

" Paste without overwrite default register
xnoremap p pgvy

" center search results
nnoremap n nzzzv
nnoremap N Nzzzv

" set moving between windows to ctrl+arrows
function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction

nnoremap <silent> <C-Left> :call WinMove('h')<CR>
nnoremap <silent> <C-Down> :call WinMove('j')<CR>
nnoremap <silent> <C-Up> :call WinMove('k')<CR>
nnoremap <silent> <C-Right> :call WinMove('l')<CR>

nnoremap <S-Down> :m .+1<CR>==
nnoremap <S-Up> :m .-2<CR>==
vnoremap <S-Down> :m '>+1<CR>gv=gv
vnoremap <S-Up> :m '<-2<CR>gv=gv

" Gitsigns
nnoremap <Leader>gb :Gitsigns toggle_current_line_blame<CR>
nnoremap <Leader>gp :Gitsigns preview_hunk<CR>
nnoremap <Leader>grh :Gitsigns reset_hunk<CR>
nnoremap <Leader>grb :Gitsigns reset_buffer<CR>

nnoremap <C-s> :w<cr>
