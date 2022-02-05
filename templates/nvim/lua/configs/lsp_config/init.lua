local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
    return
end
local status_ok, lspsignature = pcall(require, "lsp_signature")
if not status_ok then
    return
end
local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
    return
end

local signs = {
    {
        name = "DiagnosticSignError",
        text = "",
        type = "Error"
    }, {
        name = "DiagnosticSignWarn",
        text = "",
        type = "Warn"
    }, {
        name = "DiagnosticSignHint",
        text = "",
        type = "Hint"
    }, {
        name = "DiagnosticSignInfo",
        text = "",
        type = "Info"
    }
}

for _, sign in ipairs(signs) do
    local hl = "DiagnosticLineNr" .. sign.type
    vim.fn.sign_define(sign.name, {
        texthl = sign.name,
        text = sign.text,
        numhl = hl
    })
end

vim.cmd [[
  highlight DiagnosticLineNrError guifg={{base08}} gui=bold
  highlight DiagnosticLineNrWarn guifg={{base09}} gui=bold
  highlight DiagnosticLineNrInfo guifg={{base0C}} gui=bold
  highlight DiagnosticLineNrHint guifg={{base0D}} gui=bold

  sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticLineNrError
  sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticLineNrWarn
  sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticLineNrInfo
  sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticLineNrHint
]]
local config = {
    virtual_text = false,
    signs = {
        active = signs
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "single",
        source = "always",
        header = "",
        prefix = ""
    }
}

vim.diagnostic.config(config)

local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "single",
        scope = "line"
    }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "single",
        scope = "line"
    })
}

local function lsp_keymaps(bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    local opts = {
        noremap = true,
        silent = true
    }

    buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "ge", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap("n", "<space>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    buf_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    buf_set_keymap("n", "<C-b>", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "<C-n>", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
end

local function lsp_highlight_document(client)
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
    end
end

local function lsp_signature(bufnr)
    lspsignature.on_attach({
        bind = true, -- This is mandatory, otherwise border config won"t get registered.
        handler_opts = {
            border = "single"
        },
        hint_prefix = " ",
        max_height = 8
    }, bufnr)

end

local on_attach = function(client, bufnr)
    lsp_signature(bufnr)
    lsp_keymaps(bufnr)
    lsp_highlight_document(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

local flags = {
    debounce_text_changes = 150
}

-- Use a loop to conveniently call "setup" on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {"gopls"}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        handlers = handlers,
        capabilities = capabilities,
        flags = flags
    }
end

local util = require("lspconfig/util")
lspconfig.pyright.setup {
    on_attach = on_attach,
    handlers = handlers,
    capabilities = capabilities,
    flags = flags,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly'
            }
        }
    },
    root_dir = function(fname)
        return util.root_pattern(".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt")(fname) or
                   util.path.dirname(fname)
    end
}

local win = require('lspconfig.ui.windows')
local _default_opts = win.default_opts

win.default_opts = function(options)
    local opts = _default_opts(options)
    opts.border = 'single'
    return opts
end
