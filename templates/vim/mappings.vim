nnoremap <SPACE> <Nop>
let mapleader =" "

map ö {
map ä }
map ga <Nop>

" Shortcutting split navigation, saving a keypress:
map <C-M-left> <C-w>h
map <C-M-down> <C-w>j
map <C-M-up> <C-w>k
map <C-M-right> <C-w>l
map <leader>q <C-w>q

inoremap <C-Space> <C-x><C-n>

nnoremap <silent> <A-left> :bp<CR>
nnoremap <silent> <A-right> :bn<CR>
nnoremap <silent> <A-up> :Buffers<CR>

" delete visual and paste
map <leader>p "_dP

" Replace all is aliased to S.
nnoremap S :%s//g<Left><Left>

" Requires gvim
" paste with shift+insert
noremap <Leader>Y "*y<CR>
noremap <Leader>P "*p<CR>
" paste with ctrl+v
noremap <Leader>y "+y<CR>
noremap <Leader>p "+p<CR>

" Commandline
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <M-Left> <S-Left>
cnoremap <M-Right> <S-Right>
cnoremap <M-BS> <C-W>
cnoremap <C-BS> <C-W>

" Move lines
nnoremap <silent> <C-Down> :move+<cr>
nnoremap <silent> <C-Up> :move-2<cr>

" Fugitive
nnoremap <Leader>ga :Git add<Space>
nnoremap <Leader>gd :Git diff<Space>
nnoremap <Leader>gc :Git commit<Space>
nnoremap <silent> <Leader>gs :Git status<cr>
nnoremap <silent> <Leader>gl :Git log<cr>
nnoremap <silent> <Leader>gb :Git blame<cr>
nnoremap <silent> <Leader>gh :Git show HEAD<cr>
nnoremap <Leader>gp :Git push
