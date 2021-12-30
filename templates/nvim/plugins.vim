" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')

" Git
Plug 'tpope/vim-fugitive' " Git integration
Plug 'lewis6991/gitsigns.nvim' " Lua gitsigns

" Treesitter
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-treesitter/nvim-treesitter-refactor' " Refactor with LST and highlight current block

" Languages
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' } " Go support
Plug 'towolf/vim-helm' " Support for helm
Plug 'renerocksai/telekasten.nvim'

" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim' " Find everything
Plug 'nvim-telescope/telescope.nvim' " Navigation and fzf search
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" Language Server Protocol (LSP)
Plug 'neovim/nvim-lspconfig' " Configure LSP
Plug 'onsails/lspkind-nvim' " Icons for floating windows of LSP.
Plug 'ray-x/lsp_signature.nvim' " Signature help
Plug 'folke/lua-dev.nvim'

" Snippets
Plug 'hrsh7th/cmp-nvim-lsp' " Auto suggestions from LSP
Plug 'hrsh7th/cmp-buffer' " Auto suggestions
Plug 'hrsh7th/nvim-cmp' " Auto suggestions
Plug 'hrsh7th/cmp-vsnip' " Snippets
Plug 'hrsh7th/cmp-path' " Auto complete paths
Plug 'SirVer/ultisnips' " Snippets
Plug 'honza/vim-snippets' " Snippets
Plug 'quangnguyen30192/cmp-nvim-ultisnips' " Snippets

" Formatting and linting
Plug 'mfussenegger/nvim-lint' " Linting
Plug 'jose-elias-alvarez/null-ls.nvim' " formatting and possibly linting

" Look and feel
Plug 'lukas-reineke/indent-blankline.nvim' " Indentation guide
Plug 'nvim-lualine/lualine.nvim' " Statusline written in Lua, duuh..
Plug 'norcalli/nvim-colorizer.lua' " Highlight CSS colors in buffers
Plug 'kyazdani42/nvim-web-devicons' " Devicons for statusline
Plug 'karb94/neoscroll.nvim' " Smooth scrolling
Plug 'rktjmp/lush.nvim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'navarasu/onedark.nvim'
" Plug 'sunjon/shade.nvim' " Shade inactive buffers -- Buggy as hell.
Plug 'kyazdani42/nvim-tree.lua' " File Explorer
Plug 'akinsho/toggleterm.nvim' " Toggleable Terminal in vim

" Change work dir
Plug 'nanotee/zoxide.vim' " Next gen change working dirs
Plug 'jvgrootveld/telescope-zoxide' " Next gen change working dir with telescope

" Misc
Plug 'terrortylor/nvim-comment' " Neat comments
Plug 'airblade/vim-rooter' " Change PWD to project root of open buffer
Plug 'ThePrimeagen/harpoon'
Plug 'tjdevries/train.nvim' " Train movements
Plug 'andymass/vim-matchup' " Improved navigation with %-sign, now language specific
Plug 'windwp/nvim-autopairs' " Auto pair single quotes, double qoutes and more
Plug 'nathom/filetype.nvim', { 'branch': 'dev' } " Faster filetype loading
call  plug#end()
