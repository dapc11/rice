local nvim_lsp = require("lspconfig")

------ Setup gitsigns.
require('gitsigns').setup{
    keymaps = {
        -- Default keymap options
        noremap = false,
    },
}

------- Setup lint.
local lint = require("lint")

local pattern = '[^:]+:(%d+):(%d+):(%w+):(.+)'
local groups = { 'line', 'start_col', 'code', 'message' }
lint.linters.dapc_flake8 = {
    cmd = 'flake8',
    stdin = true,
    args = {
        '--format=%(path)s:%(row)d:%(col)d:%(code)s:%(text)s',
        '--no-show-source',
        '-',
    },
    ignore_exitcode = true,
    parser = require('lint.parser').from_pattern(pattern, groups, nil, {
        ['source'] = 'flake8',
        ['severity'] = vim.lsp.protocol.DiagnosticSeverity.Warning,
    }),
}

local severities = {
    error = vim.lsp.protocol.DiagnosticSeverity.Error,
    warning = vim.lsp.protocol.DiagnosticSeverity.Warning,
    refactor = vim.lsp.protocol.DiagnosticSeverity.Information,
    convention = vim.lsp.protocol.DiagnosticSeverity.Hint,
}
lint.linters.dapc_pylint = {
    cmd = 'pylint',
    stdin = false,
    args = {
        '-f', 'json', '-d', 'R0801,W1508,C0114,C0115,C0116,C0301,W0611,W1309'
    },
    ignore_exitcode = true,
    parser = function(output)
        local decoded = vim.fn.json_decode(output)
        local diagnostics = {}
        for _, item in ipairs(decoded or {}) do
            local column = 0
            if item.column > 0 then
                column = item.column - 1
            end
            table.insert(diagnostics, {
                range = {
                    ['start'] = {
                        line = item.line - 1,
                        character = column,
                    },
                    ['end'] = {
                    line = item.line - 1,
                    character = column,
                },
            },
            severity = assert(severities[item.type], 'missing mapping for severity ' .. item.type),
            source = 'pylint',
            code = (item["message-id"] and item["message-id"] or nil),
            message = item.message .. "(" .. item.symbol .. ")",
        })
    end
    return diagnostics
end,
}

lint.linters_by_ft = {
    python = {"dapc_flake8", "dapc_pylint",}
}
------ Setup formatting.
local null_ls = require("null-ls")

-- register any number of sources simultaneously
local sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.lua_format,
}

null_ls.config({ sources = sources })
nvim_lsp["null-ls"].setup({})


------ Setup treesitter.
local treesitter = require("nvim-treesitter.configs")
treesitter.setup{
    highlight = { enable = true },
    incremental_selection = { enable = true },
    textobjects = { enable = true },
    refactor = {
        highlight_definitions = { enable = true },
        highlight_current_scope = { enable = true },
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "<Space>r",
            },
        },
    },
}

------ Setup nvim-cmp.
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    mapping = {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "ultisnips" },
        { name = "vsnip" },
        { name = "buffer" },
        { name = "path" },
    }
})

------ Setup lsp_config.
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    require "lsp_signature".on_attach({
        bind = true, -- This is mandatory, otherwise border config won"t get registered.
        handler_opts = {
            border = "single"
        },
        hint_prefix = " ",
        max_height = 8,
    }, bufnr)

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "<C-e>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap("n", "<space>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
    buf_set_keymap("n", "<C-b>", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "<C-n>", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
end

-- Use a loop to conveniently call "setup" on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "gopls" }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
        flags = {
            debounce_text_changes = 150,
        }
    }
end

local util = require("lspconfig/util")
nvim_lsp.pyright.setup {
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    settings = {
        python = {
            analysis = {
                extraPaths = {"/home/daniel/repos/dapc11-rice/"},
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
            },
        },
    },
    root_dir = function(fname)
        return util.root_pattern(".git", "setup.py",  "setup.cfg", "pyproject.toml", "requirements.txt")(fname) or
        util.path.dirname(fname)
    end,
}
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        update_in_insert = false,
    }
)

do
    local method = "textDocument/publishDiagnostics"
    local default_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, method, result, client_id, bufnr, config)
        default_handler(err, method, result, client_id, bufnr, config)
        local diagnostics = vim.lsp.diagnostic.get_all()
        local qflist = {}
        for bufnr, diagnostic in pairs(diagnostics) do
            for _, d in ipairs(diagnostic) do
                d.bufnr = bufnr
                d.lnum = d.range.start.line + 1
                d.col = d.range.start.character + 1
                d.text = (d.source and "[" .. d.source .. "] " or "") .. (d.code and "[" .. d.code .. "] " or "") .. d.message
                table.insert(qflist, d)
            end
        end
        vim.lsp.util.set_qflist(qflist)
    end
end


------ Toggle term
require("toggleterm").setup{
    open_mapping = [[<c-t>]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = '1', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    persist_size = true,
    direction = 'float',
    close_on_exit = true, -- close the terminal window when the process exits
    shell = vim.o.shell, -- change the default shell
    -- This field is only relevant if direction is set to 'float'
    float_opts = {
        border = 'single',
        winblend = 3,
        highlights = {
            border = "Normal",
            background = "Normal",
        }
    }
}

function _G.set_terminal_keymaps()
  local opts = {noremap = true}
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')


------ nvim tree
require'nvim-tree'.setup{
    update_focused_file = {
        -- enables the feature
        enable      = true,
        -- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
        -- only relevant when `update_focused_file.enable` is true
        update_cwd  = false,
        -- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
        -- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
        ignore_list = {}
    }
}
