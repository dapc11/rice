set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set expandtab
set relativenumber
set hlsearch
set hidden
set noerrorbells
set nu
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set noshowmode
set completeopt=menuone,noinsert,noselect
set shiftround
set colorcolumn=80
set updatetime=50
set shortmess+=c
set clipboard+=unnamedplus
set mouse=a
" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
set splitbelow splitright
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-l>', 'n') ==# ''
  nnoremap <silent> <C-L> :let @/ = ""<CR>
endif
