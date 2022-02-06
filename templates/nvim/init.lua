local utils = require "core.utils"

utils.disabled_builtins()

utils.bootstrap()

utils.impatient()

local sources = {"core.options", "core.fzf", "core.plugins", "core.keymaps", "configs.lsp"}

for _, source in ipairs(sources) do
    local status_ok, fault = pcall(require, source)
    if not status_ok then
        error("Failed to load " .. source .. "\n\n" .. fault)
    end
end

utils.compiled()
