local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
                                  install_path})
    print("Installing packer close and reopen Neovim...")
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require('packer.util').float({
                border = 'single'
            })
        end
    }
})

-- Install your plugins here
return packer.startup(function(use)
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
    use 'nvim-treesitter/nvim-treesitter-refactor' -- Refactor with LST and highlight current block

    -- Languages
    use {
        'fatih/vim-go',
        run = ':GoUpdateBinaries'
    } -- Go support
    use 'towolf/vim-helm' -- Support for helm
    use 'renerocksai/telekasten.nvim'

    -- Fuzzy finder
    use {
        'junegunn/fzf',
        run = './install --bin'
    }
    use 'junegunn/fzf.vim' -- Find everything
    use 'nvim-telescope/telescope.nvim' -- Navigation and fzf search
    use 'nvim-telescope/telescope-fzy-native.nvim'

    -- Language Server Protocol (LSP)
    use 'neovim/nvim-lspconfig' -- Configure LSP
    use 'onsails/lspkind-nvim' -- Icons for floating windows of LSP.
    use 'ray-x/lsp_signature.nvim' -- Signature help
    use 'folke/lua-dev.nvim'

    -- Snippets
    use 'hrsh7th/cmp-nvim-lsp' -- Auto suggestions from LSP
    use 'hrsh7th/cmp-buffer' -- Auto suggestions
    use 'hrsh7th/nvim-cmp' -- Auto suggestions
    use 'hrsh7th/cmp-vsnip' -- Snippets
    use 'hrsh7th/cmp-path' -- Auto complete paths
    use 'SirVer/ultisnips' -- Snippets
    use 'honza/vim-snippets' -- Snippets
    use 'quangnguyen30192/cmp-nvim-ultisnips' -- Snippets

    -- Formatting and linting
    use 'mfussenegger/nvim-lint' -- Linting
    use 'jose-elias-alvarez/null-ls.nvim' -- formatting and possibly linting

    -- Look and feel
    use 'lukas-reineke/indent-blankline.nvim' -- Indentation guide
    use 'nvim-lualine/lualine.nvim' -- Statusline written in Lua, duuh..
    use 'norcalli/nvim-colorizer.lua' -- Highlight CSS colors in buffers
    use 'kyazdani42/nvim-web-devicons' -- Devicons for statusline
    use 'karb94/neoscroll.nvim' -- Smooth scrolling
    use 'rktjmp/lush.nvim'
    use 'ellisonleao/gruvbox.nvim'
    use 'navarasu/onedark.nvim'
    -- use 'sunjon/shade.nvim' " Shade inactive buffers -- Buggy as hell.
    use 'kyazdani42/nvim-tree.lua' -- File Explorer
    use 'akinsho/toggleterm.nvim' -- Toggleable Terminal in vim

    -- Change work dir
    use 'nanotee/zoxide.vim' -- Next gen change working dirs
    use 'jvgrootveld/telescope-zoxide' -- Next gen change working dir with telescope

    -- Misc
    use 'terrortylor/nvim-comment' -- Neat comments
    use 'airblade/vim-rooter' -- Change PWD to project root of open buffer
    use 'ThePrimeagen/harpoon'
    use 'tjdevries/train.nvim' -- Train movements
    use 'andymass/vim-matchup' -- Improved navigation with %-sign, now language specific
    use 'windwp/nvim-autopairs' -- Auto pair single quotes, double qoutes and more
    use {
        'nathom/filetype.nvim',
        branch = 'dev'
    } -- Faster filetype loading
    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require('packer').sync()
    end
end)
