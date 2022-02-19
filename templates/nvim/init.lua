local utils = require "core.utils"

utils.disabled_builtins()

utils.bootstrap()

utils.impatient()

local sources = {"core.globals", "core.options", "core.fzf", "core.plugins", "core.keymaps"}

for _, source in ipairs(sources) do
    local status_ok, fault = pcall(require, source)
    if not status_ok then
        error("Failed to load " .. source .. "\n\n" .. fault)
    end
end

hi("CmpItemAbbrMatch",       {guibg = "none", guifg = "{{base0D}}"})
hi("CmpItemAbbrMatchFuzzy",  {guibg = "none", guifg = "{{base0D}}"})
hi("CmpItemKindFunction",    {guibg = "none", guifg = "{{base0E}}"})
hi("CmpItemKindMethod",      {guibg = "none", guifg = "{{base0E}}"})
hi("CmpItemKindVariable",    {guibg = "none", guifg = "{{base0C}}"})
hi("CmpItemKindKeyword",     {guibg = "none", guifg="{{base07}}"})
hi("DiagnosticLineNrError",  {guifg = "{{base08}}"})
hi("DiagnosticLineNrWarn",   {guifg = "{{base09}}"})
hi("DiagnosticLineNrInfo",   {guifg = "{{base0C}}"})
hi("DiagnosticLineNrHint",   {guifg = "{{base0D}}"})
hi("FloatBorder",            {guifg = "{{base04}}", guibg = "{{base00}}"})
hi("NormalFloat",            {guifg = "{{base06}}", guibg = "{{base00}}"})
hi("PMenu",                  {guibg = "{{base00}}", guifg = "{{base06}}"})
hi("TelescopeResultsBorder", {guifg = "{{base05}}"})
hi("TelescopePreviewBorder", {guifg = "{{base05}}"})
hi("TelescopePromptBorder",  {guifg = "{{base05}}"})
hi("TelescopeTitle",         {gui = "bold", guifg = "{{base05}}"})
hi("TelescopeMatching",      {guifg = "{{base0D}}"})

utils.compiled()
