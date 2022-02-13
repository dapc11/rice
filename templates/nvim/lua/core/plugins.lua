local M = {}

local packer_status_ok, packer = pcall(require, "packer")
if not packer_status_ok then
    return
end

packer.startup {
    function(use)
        use {"wbthomason/packer.nvim"}
        use {"lewis6991/impatient.nvim"}
        use {
            "nathom/filetype.nvim",
            config = function()
                vim.g.did_load_filetypes = 1
            end
        }

        use {"nvim-lua/plenary.nvim"}
        use {"nvim-lua/popup.nvim"}

        use {"tpope/vim-fugitive"}
        use {
            "lewis6991/gitsigns.nvim",
            config = function()
                require "configs.gitsigns"
            end
        }

        use {
            "nvim-treesitter/nvim-treesitter",
            requires = {"nvim-treesitter/nvim-treesitter-refactor", "nvim-treesitter/nvim-treesitter-textobjects",
            "mfussenegger/nvim-ts-hint-textobject", "romgrk/nvim-treesitter-context",
            "windwp/nvim-ts-autotag"},
            config = function()
                require "configs.treesitter"
            end,
            run = ":TSUpdate"
        }

        use {
            "fatih/vim-go",
            run = ":GoUpdateBinaries",
            ft = {"go"}
        }

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
        }
        use {
            "nvim-telescope/telescope-fzf-native.nvim",
            run = "make"
        }
        use {
            "phaazon/hop.nvim",
            branch = "v1", -- optional but strongly recommended
            config = function()
                require"hop".setup {}
            end
        }

        use {
            "neovim/nvim-lspconfig",
            config = function()
                require "configs.lsp"
            end
        }
        use {"onsails/lspkind-nvim"}
        use {"ray-x/lsp_signature.nvim"}

        use {"hrsh7th/cmp-nvim-lsp"}
        use {"hrsh7th/cmp-buffer"}
        use {
            "hrsh7th/nvim-cmp",
            config = function()
                require "configs.nvim_cmp"
            end
        }
        use {"hrsh7th/cmp-path"}
        use {"hrsh7th/cmp-cmdline"}
        use {
            "L3MON4D3/LuaSnip",
            config = function()
                require "configs.luasnip"
            end
        }
        use {"saadparwaiz1/cmp_luasnip"}
        use {"rafamadriz/friendly-snippets"}

        use {
            "mfussenegger/nvim-lint",
            config = function()
                require("configs.lint")
            end
        }
        use {
            "jose-elias-alvarez/null-ls.nvim",
            config = function()
                require("configs.nullls")
            end
        }

        use {
            "lukas-reineke/indent-blankline.nvim",
            config = function()
                require "configs.indent_blankline"
            end
        }

        use {
            "nvim-lualine/lualine.nvim",
            config = function()
                require "configs.lualine"
            end
        }

        use {
            "norcalli/nvim-colorizer.lua",
            config = function()
                require"colorizer".setup()
            end,
            ft = {"json", "yaml", "css", "html"}
        }

        use {"kyazdani42/nvim-web-devicons"} -- Devicons for statusline

        use {"ellisonleao/gruvbox.nvim"}

        use {"navarasu/onedark.nvim"}

        use {
            "kyazdani42/nvim-tree.lua",
            config = function()
                require "configs.nvim_tree"
            end
        }

        use {
            "akinsho/toggleterm.nvim",
            config = function()
                require "configs.toggleterm"
            end
        }

        use {
            "terrortylor/nvim-comment",
            config = function()
                require "configs.nvim_comment"
            end
        }

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
        }

        use {
            "andymass/vim-matchup",
            opt = true,
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
