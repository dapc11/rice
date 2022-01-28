local treesitter = require("nvim-treesitter.configs")
treesitter.setup{
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
        enable = true
    },
    refactor = {
        highlight_definitions = {
            enable = true
        },
        highlight_current_scope = {
            enable = true
        },
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "<Space>rr",
            },
        },
    },
}
