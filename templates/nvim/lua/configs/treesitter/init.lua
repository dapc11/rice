local treesitter = require("nvim-treesitter.configs")
require("tsht").config.hint_keys = { "h", "j", "f", "d", "n", "v", "s", "l", "a" }
local parser_config = require'nvim-treesitter.parsers'.get_parser_configs()
parser_config.gotmpl = {
  install_info = {
    url = "https://github.com/ngalaiko/tree-sitter-go-template",
    files = {"src/parser.c"}
  },
  filetype = "gotmpl",
  used_by = {"gohtmltmpl", "gotexttmpl", "gotmpl", "yaml", "tpl"}
}
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
    autotag = {
        enable = true,
        filetypes = { "html" , "xml" },
    },
    refactor = {
        highlight_definitions = {
            enable = true,
            disable = function(lang, bufnr)
                return vim.api.nvim_buf_line_count(bufnr) > 1000
            end,
        },
        highlight_current_scope = {
            enable = false,
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
