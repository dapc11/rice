------ Setup formatting.
local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
    return
end
local status_ok, lsputils = pcall(require, "utils")
if not status_ok then
    return
end

local write_good = null_ls.builtins.diagnostics.write_good.with({
    filetypes = {"markdown", "gitcommit", "text"}
})
local dictionary = null_ls.builtins.hover.dictionary.with({
    filetypes = {"markdown", "gitcommit", "text"}
})
local black = null_ls.builtins.formatting.black.with({
    filetypes = {"python"}
})
local isort = null_ls.builtins.formatting.isort.with({
    filetypes = {"python"}
})
local gofmt = null_ls.builtins.formatting.gofmt.with({
    filetypes = {"go"}
})
local goimports = null_ls.builtins.formatting.goimports.with({
    filetypes = {"go"}
})

-- register any number of sources simultaneously
local sources = {null_ls.builtins.code_actions.gitsigns, black, isort, gofmt, goimports, write_good, dictionary}

vim.diagnostic.config(lsputils.diagnostics_config)

null_ls.setup({
    sources = sources,
    handlers = lsputils.handlers,
    on_attach = function(client, bufnr)
        if client.resolved_capabilities.document_formatting then
            vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()"
        end
        lsputils.lsp_keymaps(bufnr)
        lsputils.lsp_signature(bufnr)
    end
})
