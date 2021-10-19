" auto-install vim-plug
"
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim' " Find everything
Plug 'ap/vim-css-color' " CSS Colors ?
Plug 'tpope/vim-commentary' " Neat comments
Plug 'tpope/vim-fugitive' " Git integration
Plug 'airblade/vim-rooter' " Change PWD to project root of open buffer
Plug 'Yggdroot/indentLine'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' } " Go support
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-treesitter/nvim-treesitter-refactor' " Refactor with LST and highlight current block
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'Townk/vim-autoclose' " Autoclose quotes and brackets
Plug 'lilydjwg/colorizer' " CSS colors
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'neovim/nvim-lspconfig' " LSP
Plug 'hrsh7th/cmp-nvim-lsp' " Auto suggestions from LSP
Plug 'hrsh7th/cmp-buffer' " Auto suggestions
Plug 'hrsh7th/nvim-cmp' " Auto suggestions
" For vsnip user.
Plug 'hrsh7th/cmp-vsnip' " Snippets
Plug 'hrsh7th/vim-vsnip' " Snippets
Plug 'hrsh7th/cmp-path' " Auto complete paths
Plug 'mfussenegger/nvim-lint' " Linting
" Track the engine.
" Snippets are separated from the engine. Add this if you want them:
Plug 'SirVer/ultisnips' " Snippets
Plug 'honza/vim-snippets' " Snippets
Plug 'quangnguyen30192/cmp-nvim-ultisnips' " Snippets
Plug 'ray-x/lsp_signature.nvim' " Signature help
Plug 'jose-elias-alvarez/null-ls.nvim' " formatting and possibly linting
Plug 'lewis6991/gitsigns.nvim' " Lua gitsigns
Plug 'akinsho/toggleterm.nvim' " Terminal in vim
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'
call plug#end()

nnoremap <C-e> :NvimTreeToggle<CR>
let g:nvim_tree_icons = {}
let g:nvim_tree_show_icons = {
    \ 'git': 0,
    \ 'folders': 1,
    \ 'files': 0,
    \ 'folder_arrows': 1,
    \ }

let g:rooter_patterns = ['.git', 'src', 'pom.xml', 'Makefile', '*.sln', 'build/env.sh']
let g:rooter_change_directory_for_non_project_files = 'home'
let g:indentLine_setConceal = 0
let g:python3_host_prog = '~/dev/bin/python3'

nmap <leader>gs :Git<CR>

" unmap <space>hR
" unmap <space>hu
" unmap <space>hb
" unmap <space>hs
" unmap <space>hS
" unmap <space>hs
" unmap <space>hU
" unmap <space>hp
" unmap <space>hr
" unmap <space>hr
