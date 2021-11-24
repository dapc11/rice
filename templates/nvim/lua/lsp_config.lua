local nvim_lsp = require("lspconfig")

------ Setup lualine
require'lualine'.setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {},
        always_divide_middle = true,
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff',
        {'diagnostics', sources={'nvim_lsp'}}},
        lualine_c = { {'filename', file_status = true, path = 1, shorting_target = 40}},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
}

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
        '--ignore=W503',
        '--per-file-ignores = **/test_*:D100,D103',
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
    fatal = vim.lsp.protocol.DiagnosticSeverity.Fatal,
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
    incremental_selection = { enable = false },
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


local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

------ Setup nvim-cmp.
local cmp = require("cmp")
cmp.setup{
    completion = {
        keyword_pattern  = "ääääääää",
        keyword_length = 1
    },
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    mapping = {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-x>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = function(fallback)
            if not cmp.select_next_item() then
                if vim.bo.buftype ~= "prompt" and has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end
        end,
        ["<S-Tab>"] = function(fallback)
            if not cmp.select_prev_item() then
                if vim.bo.buftype ~= "prompt" and has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end
        end,
        ["<Down>"] = function(fallback)
            if not cmp.select_next_item() then
                if vim.bo.buftype ~= "prompt" and has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end
        end,
        ["<Up>"] = function(fallback)
            if not cmp.select_prev_item() then
                if vim.bo.buftype ~= "prompt" and has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end
        end,
        -- ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        -- ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    },
    sources = {
        { name = "nvim_lsp", priority = 5 },
        { name = "path" },
        { name = "buffer", max_item_count = 3, priority = 3 },
        { name = "ultisnips", max_item_count = 3 },
    },
    formatting = {
        format = function(entry, vim_item)
            -- fancy icons and a name of kind
            vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
            return vim_item
        end
    }
}

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
    buf_set_keymap("n", "<F4>", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
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
local system_name
if vim.fn.has("mac") == 1 then
    system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
    system_name = "Windows"
else
    print("Unsupported system for sumneko")
end

-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = os.getenv("HOME")..'/.local/bin'
local sumneko_binary = sumneko_root_path.."/lua-language-server"

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path,
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
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

------ telescope
require('telescope').setup {
    extensions = {
        fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
    }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzy_native')

--- indentation guide
vim.opt.list = true
vim.cmd [[highlight IndentBlanklineChar guifg={{base02}} gui=nocombine]]

require("indent_blankline").setup {
    show_end_of_line = false,
    space_char_blankline = " "
}

local z_utils = require("telescope._extensions.zoxide.utils")

require("telescope._extensions.zoxide.config").setup({
  prompt_title = "Change working dir",
  mappings = {
    default = {
      after_action = function(selection)
        print("Update to (" .. selection.z_score .. ") " .. selection.path)
      end
    },
    ["<C-s>"] = {
      before_action = function(selection) print("before C-s") end,
      action = function(selection)
        vim.cmd("edit " .. selection.path)
      end
    },
    ["<C-q>"] = { action = z_utils.create_basic_command("split") },
  }
})

vim.api.nvim_set_keymap(
	"n",
	"<leader>cd",
	":lua require'telescope'.extensions.zoxide.list{}<CR>",
	{noremap = true, silent = true}
)
