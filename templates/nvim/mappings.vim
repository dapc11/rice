nnoremap <SPACE> <Nop>
let mapleader =" "

map ö {
map ä }
map ga <Nop>

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
nnoremap <C-s> :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Navigate errors
nnoremap <C-n> :cn<CR>
nnoremap <C-b> :cp<CR>

" Paste without overwrite default register
xnoremap p pgvy

" center search results
nnoremap n nzzzv
nnoremap N Nzzzv

" Close all buffers but the opened one
map <Leader>a :cclose <bar> lclose <bar> pclose<CR>

" set moving between windows to ctrl+arrows
nnoremap <silent> <C-Right> <c-w>l
nnoremap <silent> <C-Left> <c-w>h
nnoremap <silent> <C-Up> <c-w>k
nnoremap <silent> <C-Down> <c-w>j
map <C-k> <Nop>
nnoremap <C-k> :vsplit<CR>
map <C-j> <Nop>
nnoremap <C-j> :split<CR>

nnoremap <S-Down> :m .+1<CR>==
nnoremap <S-Up> :m .-2<CR>==
vnoremap <S-Down> :m '>+1<CR>gv=gv
vnoremap <S-Up> :m '<-2<CR>gv=gv

nnoremap <Leader>gb :Gitsigns toggle_current_line_blame<CR>
