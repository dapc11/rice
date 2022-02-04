local M = {}

local packer_status_ok, packer = pcall(require, "packer")
if not packer_status_ok then
    return
end

packer.startup {
    function(use)
        -- Plugin manager
        use {"wbthomason/packer.nvim"}

        -- Optimiser
        use {"lewis6991/impatient.nvim"}

        -- Lua functions
        use {"nvim-lua/plenary.nvim"}

        -- Popup API
        use {"nvim-lua/popup.nvim"}

        -- Boost startup time
        use {
            "nathom/filetype.nvim",
            config = function()
                vim.g.did_load_filetypes = 1
            end
        }

        use {"tpope/vim-fugitive"} -- Git integration
        use {
            "lewis6991/gitsigns.nvim",
            config = function()
                require "configs.gitsigns"
            end
        } -- Lua gitsigns
        -- Treesitter
        use {
            "nvim-treesitter/nvim-treesitter",
            requires = {"nvim-treesitter/nvim-treesitter-refactor", "nvim-treesitter/nvim-treesitter-textobjects",
                        "mfussenegger/nvim-ts-hint-textobject", "romgrk/nvim-treesitter-context",
                        "windwp/nvim-ts-autotag"},
            config = function()
                require "configs.treesitter"
            end,
            run = ":TSUpdate"
        } -- We recommend updating the parsers on update

        -- Languages
        use {
            "fatih/vim-go",
            run = ":GoUpdateBinaries",
            ft = {"go"}
        } -- Go support

        -- Fuzzy finder
        use {
            "junegunn/fzf",
            run = "./install --bin"
        }
        use {"junegunn/fzf.vim"} -- Find everything
        use {
            "nvim-telescope/telescope.nvim",
            config = function()
                require "configs.telescope"
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
                require'hop'.setup {}
            end
        }

        -- Language Server Protocol (LSP)
        use {
            "neovim/nvim-lspconfig",
            config = function()
                require "configs.lsp_config"
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
                require "configs.nvim_cmp"
            end
        } -- Auto suggestions
        use {"hrsh7th/cmp-path"} -- Auto complete paths
        use {"hrsh7th/cmp-cmdline"}
        use {
            "L3MON4D3/LuaSnip",
            config = function()
                require "configs.luasnip"
            end
        }
        use {"saadparwaiz1/cmp_luasnip"}
        use {"rafamadriz/friendly-snippets"}

        -- Formatting and linting
        use {
            "mfussenegger/nvim-lint",
            ft = "python",
            config = function()
                require("configs.lint")
            end
        } -- Linting
        use {
            "jose-elias-alvarez/null-ls.nvim",
            config = function()
                require("configs.nullls")
            end,
            ft = {"go", "python"}
        } -- formatting and possibly linting

        -- Look and feel
        use {
            "lukas-reineke/indent-blankline.nvim",
            config = function()
                require "configs.indent_blankline"
            end
        } -- Indentation guide
        use {
            "nvim-lualine/lualine.nvim",
            config = function()
                require "configs.lualine"
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
                require "configs.nvim_tree"
            end
        } -- File Explorer
        -- use {
        --     "akinsho/toggleterm.nvim",
        --     config = function()
        --         require "configs.toggleterm"
        --     end
        -- } -- Toggleable Terminal in vim

        -- Misc
        use {
            "terrortylor/nvim-comment",
            config = function()
                require "configs.nvim_comment"
            end
        } -- Neat comments
        -- use {"airblade/vim-rooter"} -- Change PWD to project root of open buffer
        use {
            "dapc11/project.nvim",
            config = function()
                require("project_nvim").setup({})
            end
        }
        use {"ThePrimeagen/harpoon"}
        use {
            "windwp/nvim-autopairs",
            event = "InsertEnter",
            config = function()
                require"configs.autopairs".config()
            end
        } -- Auto pair single quotes, double qoutes and more

        use {
            "cuducos/yaml.nvim",
            ft = {"yaml"}, -- optional
            requires = {"nvim-treesitter/nvim-treesitter", "nvim-telescope/telescope.nvim" -- optional
            },
            config = function()
                require("yaml_nvim").init()
            end
        }
    end,
    config = {
        compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
        profile = {
            enable = true,
            threshold = 0.0001
        },
        git = {
            clone_timeout = 300
        },
        auto_clean = true,
        compile_on_sync = true
    }
}

return M
