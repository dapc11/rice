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

inoremap <C-Space> <C-x><C-n>

nnoremap <silent> <A-left> :bp<CR>
nnoremap <silent> <A-right> :bn<CR>

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

" Fugitive
nnoremap <Leader>la :Git add<Space>
nnoremap <Leader>ld :Git diff<Space>
nnoremap <Leader>lc :Git commit<Space>
nnoremap <silent> <Leader>ls :Gstatus<cr>
nnoremap <silent> <Leader>ll :Glog<cr>
nnoremap <silent> <Leader>lb :Gblame<cr>
nnoremap <silent> <Leader>lh :Git show HEAD<cr>
nnoremap <Leader>lp :Git push

" Select and search
vnoremap <C-f> y/\V<C-R>=escape(@",'/\')<CR><CR>
" Paste over select and keep register
vnoremap <leader>p "_dP

" :e sane mappings
set wildcharm=<C-Z>
cnoremap <expr> <up> wildmenumode() ? "\<left>" : "\<up>"
cnoremap <expr> <down> wildmenumode() ? "\<right>" : "\<down>"
cnoremap <expr> <left> wildmenumode() ? "\<up>" : "\<left>"
cnoremap <expr> <right> wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"

" Search and replace with prompt
nnoremap <leader>r yiw:%s/\<<C-r>"\>//gc<left><left><left>


nnoremap <C-n> :cn<CR>
nnoremap <C-p> :cp<CR>
