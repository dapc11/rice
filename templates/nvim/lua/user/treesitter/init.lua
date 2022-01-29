local treesitter = require("nvim-treesitter.configs")
treesitter.setup{
    ensure_installed = {"python", "lua", "dockerfile", "json", "yaml", "css", "html", "go", "bash", "java", "vim", "toml", "markdown" },
    highlight = {
        enable = true,
        disable = function(lang, bufnr)
            return vim.api.nvim_buf_line_count(bufnr) > 1000
        end,
        -- additional_vim_regex_highlighting = { "python" }
    },
    incremental_selection = {
        enable = false
    },
    textobjects = {
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },
        disable = function(lang, bufnr)
            return vim.api.nvim_buf_line_count(bufnr) > 1000
        end,
    },
    refactor = {
        highlight_definitions = {
            enable = true,
            disable = function(lang, bufnr)
                return vim.api.nvim_buf_line_count(bufnr) > 1000
            end,
        },
        highlight_current_scope = {
            enable = true,
            disable = function(lang, bufnr)
                return vim.api.nvim_buf_line_count(bufnr) > 1000
            end,
        },
        smart_rename = {
            enable = true,
            disable = function(lang, bufnr)
                return vim.api.nvim_buf_line_count(bufnr) > 1000
            end,
            keymaps = {
                smart_rename = "<Space>rr",
            },
        },
    },
}
