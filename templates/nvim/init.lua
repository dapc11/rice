local utils = require "core.utils"

utils.disabled_builtins()

utils.bootstrap()

utils.impatient()

local sources = {"core.options", "core.fzf", "core.plugins", "core.keymaps"}

for _, source in ipairs(sources) do
    local status_ok, fault = pcall(require, source)
    if not status_ok then
        error("Failed to load " .. source .. "\n\n" .. fault)
    end
end

vim.cmd[[
highlight! CmpItemAbbrMatch guibg=NONE guifg={{base0D}}
highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg={{base0D}}
highlight! CmpItemKindFunction guibg=NONE guifg={{base0E}}
highlight! CmpItemKindMethod guibg=NONE guifg={{base0E}}
highlight! CmpItemKindVariable guibg=NONE guifg={{base0C}}
highlight! CmpItemKindKeyword guibg=NONE guifg={{base07}}
highlight DiagnosticLineNrError guifg={{base08}}
highlight DiagnosticLineNrWarn guifg={{base09}}
highlight DiagnosticLineNrInfo guifg={{base0C}}
highlight DiagnosticLineNrHint guifg={{base0D}}
highlight FloatBorder guifg={{base04}} guibg={{base00}}
highlight NormalFloat guifg={{base0A}} guibg={{base00}}
highlight PMenu guibg={{base00}} guifg={{base06}}
]]

utils.compiled()
