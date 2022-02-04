------ Setup formatting.
local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
    return
end

-- register any number of sources simultaneously
local sources = {
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.formatting.isort,
}

null_ls.setup({
    sources = sources,
    on_attach = function(client)
      if client.resolved_capabilities.document_formatting then
        vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()"
      end
    end,
})
