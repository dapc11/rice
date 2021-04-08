set tabstop=4 softtabstop=4
set shiftwidth=4                            " 4 spaces
set shiftround                              " Round tabs to multiplier of shiftwicth
set smartindent
set expandtab                               " In Insert mode: Use the appropriate number of spaces to insert a tab
set relativenumber                          " relative line numbers to current line
set cursorline                              " Highlgiht cursor line
set hlsearch                                " Highlight search
set hidden
set noerrorbells                            " No sound on error
set nu                                      " Line numbers
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch                               " Evolve search as I write
set termguicolors                           " Make colorscheme work
set scrolloff=8                             " Start scroll when n lines from screen edge
set noshowmode
set completeopt=menuone,noinsert,noselect   " Autocompletion
set colorcolumn=80                          " Dont go further
set updatetime=50                           " Short time to combo key strokes
set shortmess+=c
set clipboard+=unnamedplus                  " System clipboard
set mouse=a                                 " Enable mouse
set backspace=indent,eol,start

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
set splitbelow splitright

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-l>', 'n') ==# ''
  nnoremap <silent> <C-L> :let @/ = ""<CR>
endif

" Python
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
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
