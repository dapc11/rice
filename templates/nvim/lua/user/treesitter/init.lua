local treesitter = require("nvim-treesitter.configs")
treesitter.setup{
    highlight = {
        enable = true,
        -- additional_vim_regex_highlighting = { "python" }
    },
    incremental_selection = {
        enable = false
    },
    textobjects = {
        enable = true
    },
    matchup = {
        enable = true
    },
    refactor = {
        highlight_definitions = {
            enable = true
        },
        highlight_current_scope = {
            enable = false
        },
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "<Space>rr",
            },
        },
    },
}
