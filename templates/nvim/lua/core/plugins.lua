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
            branch = "dev", -- optional but strongly recommended
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
                require("configs.autopairs").config()
            end
        }

        use {
            "andymass/vim-matchup",
            opt = true,
        }
        use {'kevinhwang91/nvim-bqf', ft = 'qf'}
        use {
            "folke/trouble.nvim",
            requires = "kyazdani42/nvim-web-devicons",
            config = function()
                require("trouble").setup {
                    mode = "document_diagnostics"
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
                }
            end
        }
        use { "junegunn/vim-easy-align" }
        use {
            'stevearc/aerial.nvim',
            config = function()
                require("aerial").setup({
                    -- Priority list of preferred backends for aerial.
                    -- This can be a filetype map (see :help aerial-filetype-map)
                    backends = { "lsp", "treesitter", "markdown" },

                    -- Enum: persist, close, auto, global
                    --   persist - aerial window will stay open until closed
                    --   close   - aerial window will close when original file is no longer visible
                    --   auto    - aerial window will stay open as long as there is a visible
                    --             buffer to attach to
                    --   global  - same as 'persist', and will always show symbols for the current buffer
                    close_behavior = "auto",

                    -- Set to false to remove the default keybindings for the aerial buffer
                    default_bindings = true,

                    -- Enum: prefer_right, prefer_left, right, left, float
                    -- Determines the default direction to open the aerial window. The 'prefer'
                    -- options will open the window in the other direction *if* there is a
                    -- different buffer in the way of the preferred direction
                    default_direction = "prefer_right",

                    -- Disable aerial on files with this many lines
                    disable_max_lines = 10000,

                    -- A list of all symbols to display. Set to false to display all symbols.
                    -- This can be a filetype map (see :help aerial-filetype-map)
                    -- To see all available values, see :help SymbolKind
                    filter_kind = {
                    "Class",
                    "Constructor",
                    "Enum",
                    "Function",
                    "Interface",
                    "Module",
                    "Method",
                    "Struct",
                    },

                    -- Enum: split_width, full_width, last, none
                    -- Determines line highlighting mode when multiple splits are visible.
                    -- split_width   Each open window will have its cursor location marked in the
                    --               aerial buffer. Each line will only be partially highlighted
                    --               to indicate which window is at that location.
                    -- full_width    Each open window will have its cursor location marked as a
                    --               full-width highlight in the aerial buffer.
                    -- last          Only the most-recently focused window will have its location
                    --               marked in the aerial buffer.
                    -- none          Do not show the cursor locations in the aerial window.
                    highlight_mode = "split_width",

                    -- Highlight the closest symbol if the cursor is not exactly on one.
                    highlight_closest = true,

                    -- When jumping to a symbol, highlight the line for this many ms.
                    -- Set to false to disable
                    highlight_on_jump = 300,

                    -- Define symbol icons. You can also specify "<Symbol>Collapsed" to change the
                    -- icon when the tree is collapsed at that symbol, or "Collapsed" to specify a
                    -- default collapsed icon. The default icon set is determined by the
                    -- "nerd_font" option below.
                    -- If you have lspkind-nvim installed, aerial will use it for icons.
                    icons = {},

                    -- Control which windows and buffers aerial should ignore.
                    -- If close_behavior is "global", focusing an ignored window/buffer will
                    -- not cause the aerial window to update.
                    -- If open_automatic is true, focusing an ignored window/buffer will not
                    -- cause an aerial window to open.
                    -- If open_automatic is a function, ignore rules have no effect on aerial
                    -- window opening behavior; it's entirely handled by the open_automatic
                    -- function.
                    ignore = {
                        -- Ignore unlisted buffers. See :help buflisted
                        unlisted_buffers = true,

                        -- List of filetypes to ignore.
                        filetypes = {},

                        -- Ignored buftypes.
                        -- Can be one of the following:
                        -- false or nil - No buftypes are ignored.
                        -- "special"    - All buffers other than normal buffers are ignored.
                        -- table        - A list of buftypes to ignore. See :help buftype for the
                        --                possible values.
                        -- function     - A function that returns true if the buffer should be
                        --                ignored or false if it should not be ignored.
                        --                Takes two arguments, `bufnr` and `buftype`.
                        buftypes = "special",

                        -- Ignored wintypes.
                        -- Can be one of the following:
                        -- false or nil - No wintypes are ignored.
                        -- "special"    - All windows other than normal windows are ignored.
                        -- table        - A list of wintypes to ignore. See :help win_gettype() for the
                        --                possible values.
                        -- function     - A function that returns true if the window should be
                        --                ignored or false if it should not be ignored.
                        --                Takes two arguments, `winid` and `wintype`.
                        wintypes = "special",
                    },

                    -- When you fold code with za, zo, or zc, update the aerial tree as well.
                    -- Only works when manage_folds = true
                    link_folds_to_tree = true,

                    -- Fold code when you open/collapse symbols in the tree.
                    -- Only works when manage_folds = true
                    link_tree_to_folds = true,

                    -- Use symbol tree for folding. Set to true or false to enable/disable
                    -- 'auto' will manage folds if your previous foldmethod was 'manual'
                    manage_folds = true,

                    -- These control the width of the aerial window.
                    -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                    -- min_width and max_width can be a list of mixed types.
                    -- max_value = {40, 0.2} means "the lesser of 40 columns or 20% of total"
                    max_width = { 40, 0.2 },
                    width = nil,
                    min_width = 10,

                    -- Set default symbol icons to use patched font icons (see https://www.nerdfonts.com/)
                    -- "auto" will set it to true if nvim-web-devicons or lspkind-nvim is installed.
                    nerd_font = "auto",

                    -- Call this function when aerial attaches to a buffer.
                    -- Useful for setting keymaps. Takes a single `bufnr` argument.
                    on_attach = nil,

                    -- Automatically open aerial when entering supported buffers.
                    -- This can be a function (see :help aerial-open-automatic)
                    open_automatic = false,

                    -- Set to true to only open aerial at the far right/left of the editor
                    -- Default behavior opens aerial relative to current window
                    placement_editor_edge = false,

                    -- Run this command after jumping to a symbol (false will disable)
                    post_jump_cmd = "normal! zz",

                    -- When true, aerial will automatically close after jumping to a symbol
                    close_on_select = false,

                    -- Show box drawing characters for the tree hierarchy
                    show_guides = false,

                    -- The autocmds that trigger symbols update (not used for LSP backend)
                    update_events = "TextChanged,InsertLeave",

                    -- Customize the characters used when show_guides = true
                    guides = {
                        -- When the child item has a sibling below it
                        mid_item = "├─",
                        -- When the child item is the last in the list
                        last_item = "└─",
                        -- When there are nested child guides to the right
                        nested_top = "│ ",
                        -- Raw indentation
                        whitespace = "  ",
                    },

                    -- Options for opening aerial in a floating win
                    float = {
                    -- Controls border appearance. Passed to nvim_open_win
                        border = "single",

                        -- Enum: cursor, editor, win
                        --   cursor - Opens float on top of the cursor
                        --   editor - Opens float centered in the editor
                        --   win    - Opens float centered in the window
                        relative = "cursor",

                        -- These control the height of the floating window.
                        -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                        -- min_height and max_height can be a list of mixed types.
                        -- min_value = {8, 0.1} means "the greater of 8 rows or 10% of total"
                        max_height = 0.9,
                        height = nil,
                        min_height = { 8, 0.1 },

                        override = function(conf)
                            -- This is the config that will be passed to nvim_open_win.
                            -- Change values here to customize the layout
                            return conf
                        end,
                    },

                    lsp = {
                        -- Fetch document symbols when LSP diagnostics update.
                        -- If false, will update on buffer changes.
                        diagnostics_trigger_update = true,

                        -- Set to false to not update the symbols when there are LSP errors
                        update_when_errors = true,
                    },

                    treesitter = {
                        -- How long to wait (in ms) after a buffer change before updating
                        update_delay = 300,
                    },

                    markdown = {
                        -- How long to wait (in ms) after a buffer change before updating
                        update_delay = 300,
                    },
                })
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
