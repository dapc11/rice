local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
    return
end
local status_ok, lsputils = pcall(require, "configs.lsp.utils")
if not status_ok then
    return
end

vim.diagnostic.config(lsputils.diagnostics_config)

local on_attach = function(client, bufnr)
    lsputils.lsp_signature(bufnr)
    lsputils.lsp_keymaps(bufnr)
    lsputils.lsp_highlight_document(client)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
    require("aerial").on_attach(client, bufnr)
end

-- Use a loop to conveniently call "setup" on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {"gopls"}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        handlers = lsputils.handlers,
        capabilities = lsputils.capabilities,
        flags = lsputils.flags
    }
end

lspconfig.yamlls.setup{
    on_attach = on_attach,
    handlers = lsputils.handlers,
    capabilities = lsputils.capabilities,
    flags = lsputils.flags,
    settings = {
        yaml = {
            schemas = { kubernetes = "*.yaml" },
        }
    }
}

local util = require("lspconfig/util")
lspconfig.pyright.setup {
    on_attach = on_attach,
    handlers = lsputils.handlers,
    capabilities = lsputils.capabilities,
    flags = lsputils.flags,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = 'off',
                autoSearchPaths = true,
                useLibraryCodeForTypes = false,
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
