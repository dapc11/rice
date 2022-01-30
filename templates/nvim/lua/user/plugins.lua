local fn = vim.fn

local function load_plugins()
    _ = vim.cmd [[packadd packer.nvim]]

    local use = require("packer").use
    require("packer").startup({
        function()
            use "wbthomason/packer.nvim"

            use {"tpope/vim-fugitive"} -- Git integration
            use {
                "lewis6991/gitsigns.nvim",
                config = function()
                    require "user.gitsigns"
                end
            } -- Lua gitsigns

            -- Treesitter
            use {"nvim-lua/popup.nvim"}
            use {"nvim-lua/plenary.nvim"}
            use {
                "nvim-treesitter/nvim-treesitter",
                requires = {"nvim-treesitter/nvim-treesitter-refactor", "nvim-treesitter/nvim-treesitter-textobjects",
                            "mfussenegger/nvim-ts-hint-textobject", "romgrk/nvim-treesitter-context",
                            "windwp/nvim-ts-autotag"},
                config = function()
                    require "user.treesitter"
                end,
                run = ":TSUpdate"
            } -- We recommend updating the parsers on update

            -- Languages
            use {
                "fatih/vim-go",
                run = ":GoUpdateBinaries",
                ft = {"go"}
            } -- Go support
            use {
                "renerocksai/telekasten.nvim",
                config = function()
                    require("user.telekasten")
                end,
                ft = {"markdown", "md", "telekasten"}
            }

            -- Fuzzy finder
            use {
                "junegunn/fzf",
                run = "./install --bin"
            }
            use {"junegunn/fzf.vim"} -- Find everything
            use {
                "nvim-telescope/telescope.nvim",
                config = function()
                    require "user.telescope"
                end
            } -- Navigation and fzf search
            use {
                "nvim-telescope/telescope-fzf-native.nvim",
                run = "make"
            }
            use {
                'phaazon/hop.nvim',
                branch = 'v1', -- optional but strongly recommended
                config = function()
                    -- you can configure Hop the way you like here; see :h hop-config
                    require'hop'.setup {
                        keys = 'etovxqpdygfblzhckisuran'
                    }
                end
            }

            -- Language Server Protocol (LSP)
            use {
                "neovim/nvim-lspconfig",
                config = function()
                    require "user.lsp_config"
                end
            } -- Configure LSP
            use {"onsails/lspkind-nvim"} -- Icons for floating windows of LSP.
            use {"ray-x/lsp_signature.nvim"} -- Signature help

            -- Snippets
            use {"hrsh7th/cmp-nvim-lsp"} -- Auto suggestions from LSP
            use {"hrsh7th/cmp-buffer"} -- Auto suggestions
            use {
                "hrsh7th/nvim-cmp",
                config = function()
                    require "user.nvim_cmp"
                end
            } -- Auto suggestions
            use {"hrsh7th/cmp-path"} -- Auto complete paths
            use {"hrsh7th/cmp-cmdline"}
            use {"L3MON4D3/LuaSnip"}
            use {"saadparwaiz1/cmp_luasnip"}
            use {"rafamadriz/friendly-snippets"}

            -- Formatting and linting
            use {
                "mfussenegger/nvim-lint",
                ft = "python",
                config = function()
                    require("user.lint")
                end
            } -- Linting
            use {
                "jose-elias-alvarez/null-ls.nvim",
                config = function()
                    require("user.nullls")
                end,
                ft = {"go", "python"}
            } -- formatting and possibly linting

            -- Look and feel
            use {
                "lukas-reineke/indent-blankline.nvim",
                config = function()
                    require "user.indent_blankline"
                end
            } -- Indentation guide
            use {
                "nvim-lualine/lualine.nvim",
                config = function()
                    require "user.lualine"
                end
            } -- Statusline written in Lua, duuh..
            use {
                "norcalli/nvim-colorizer.lua",
                config = function()
                    require"colorizer".setup()
                end,
                ft = {"json", "yaml", "css", "html"}
            } -- Highlight CSS colors in buffers
            use {"kyazdani42/nvim-web-devicons"} -- Devicons for statusline
            use {"ellisonleao/gruvbox.nvim"}
            use {"navarasu/onedark.nvim"}
            -- use "sunjon/shade.nvim" " Shade inactive buffers -- Buggy as hell.
            use {
                "kyazdani42/nvim-tree.lua",
                config = function()
                    require "user.nvim_tree"
                end
            } -- File Explorer
            use {
                "akinsho/toggleterm.nvim",
                config = function()
                    require "user.toggleterm"
                end
            } -- Toggleable Terminal in vim

            -- Misc
            use {
                "terrortylor/nvim-comment",
                config = function()
                    require "user.nvim_comment"
                end
            } -- Neat comments
            use {"airblade/vim-rooter"} -- Change PWD to project root of open buffer
            use {"ThePrimeagen/harpoon"}
            use {
                "windwp/nvim-autopairs",
                config = function()
                    require "user.autopairs"
                end
            } -- Auto pair single quotes, double qoutes and more
            use {
                "nathom/filetype.nvim",
                branch = "dev",
                config = function()
                    require "user.filetype"
                end
            } -- Faster filetype loading
        end,
        config = {
            package_root = fn.stdpath("data") .. "/site/pack/"
        }
    })
end

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.isdirectory(install_path) == 0 then
    fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
    load_plugins()
    require("packer").sync()
else
    load_plugins()
end

