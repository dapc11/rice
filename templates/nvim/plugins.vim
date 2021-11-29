" auto-install vim-plug
"
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim' " Find everything
Plug 'terrortylor/nvim-comment' " Neat comments
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
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'neovim/nvim-lspconfig' " LSP
Plug 'hrsh7th/cmp-nvim-lsp' " Auto suggestions from LSP
Plug 'hrsh7th/cmp-buffer' " Auto suggestions
Plug 'hrsh7th/nvim-cmp' " Auto suggestions
Plug 'onsails/lspkind-nvim'
Plug 'hrsh7th/cmp-vsnip' " Snippets
Plug 'hrsh7th/cmp-path' " Auto complete paths
Plug 'mfussenegger/nvim-lint' " Linting
" Track the engine.
" Snippets are separated from the engine.
Plug 'SirVer/ultisnips' " Snippets
Plug 'honza/vim-snippets' " Snippets
Plug 'quangnguyen30192/cmp-nvim-ultisnips' " Snippets
Plug 'ray-x/lsp_signature.nvim' " Signature help
Plug 'jose-elias-alvarez/null-ls.nvim' " formatting and possibly linting
Plug 'lewis6991/gitsigns.nvim' " Lua gitsigns
Plug 'akinsho/toggleterm.nvim' " Terminal in vim
Plug 'ThePrimeagen/harpoon'
Plug 'towolf/vim-helm' " Support for helm
Plug 'lukas-reineke/indent-blankline.nvim' " Indentation guide
Plug 'nvim-lualine/lualine.nvim' " Statusline written in Lua, duuh..
Plug 'kyazdani42/nvim-web-devicons' " Devicons for statusline
Plug 'jvgrootveld/telescope-zoxide'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'tjdevries/train.nvim'
Plug 'andymass/vim-matchup'
Plug 'windwp/nvim-autopairs'
Plug 'karb94/neoscroll.nvim'
Plug 'nathom/filetype.nvim'
call plug#end()
