local utils = require "core.utils"

utils.disabled_builtins()

utils.bootstrap()

utils.impatient()

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


local sources = {"core.options", "core.fzf", "core.plugins", "core.keymaps"}

for _, source in ipairs(sources) do
    local status_ok, fault = pcall(require, source)
    if not status_ok then
        error("Failed to load " .. source .. "\n\n" .. fault)
    end
end

utils.compiled()
