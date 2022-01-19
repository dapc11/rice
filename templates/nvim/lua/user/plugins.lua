local use = require('packer').use
require('packer').startup(function()
    use 'wbthomason/packer.nvim' -- Package manager itself.

    use 'tpope/vim-fugitive' -- Git integration
    use 'lewis6991/gitsigns.nvim' -- Lua gitsigns

    -- Treesitter
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    } -- We recommend updating the parsers on update

    -- Languages
    use { 'fatih/vim-go', run = ':GoUpdateBinaries', ft = 'go' } -- Go support
    use 'renerocksai/telekasten.nvim'

    -- Fuzzy finder
    use {
        'junegunn/fzf',
        run = './install --bin'
    }
    use 'junegunn/fzf.vim' -- Find everything
    use 'nvim-telescope/telescope.nvim' -- Navigation and fzf search
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    -- Language Server Protocol (LSP)
    use 'neovim/nvim-lspconfig' -- Configure LSP
    use 'onsails/lspkind-nvim' -- Icons for floating windows of LSP.
    use 'ray-x/lsp_signature.nvim' -- Signature help

    -- Snippets
    use 'hrsh7th/cmp-nvim-lsp' -- Auto suggestions from LSP
    use 'hrsh7th/cmp-buffer' -- Auto suggestions
    use 'hrsh7th/nvim-cmp' -- Auto suggestions
    use 'hrsh7th/cmp-path' -- Auto complete paths
    use 'hrsh7th/cmp-cmdline'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use "rafamadriz/friendly-snippets"
    -- use 'SirVer/ultisnips' -- Snippets
    -- use 'honza/vim-snippets' -- Snippets
    -- use 'quangnguyen30192/cmp-nvim-ultisnips' -- Snippets

    -- Formatting and linting
    use 'mfussenegger/nvim-lint' -- Linting
    use 'jose-elias-alvarez/null-ls.nvim' -- formatting and possibly linting

    -- Look and feel
    use 'lukas-reineke/indent-blankline.nvim' -- Indentation guide
    use 'nvim-lualine/lualine.nvim' -- Statusline written in Lua, duuh..
    use 'norcalli/nvim-colorizer.lua' -- Highlight CSS colors in buffers
    use 'kyazdani42/nvim-web-devicons' -- Devicons for statusline
    use 'ellisonleao/gruvbox.nvim'
    use 'navarasu/onedark.nvim'
    -- use 'sunjon/shade.nvim' " Shade inactive buffers -- Buggy as hell.
    use 'kyazdani42/nvim-tree.lua' -- File Explorer
    use 'akinsho/toggleterm.nvim' -- Toggleable Terminal in vim
    use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}

    -- Misc
    use 'terrortylor/nvim-comment' -- Neat comments
    use 'airblade/vim-rooter' -- Change PWD to project root of open buffer
    use 'ThePrimeagen/harpoon'
    use 'windwp/nvim-autopairs' -- Auto pair single quotes, double qoutes and more
    use { 'nathom/filetype.nvim',  branch = 'dev' } -- Faster filetype loading
end)
