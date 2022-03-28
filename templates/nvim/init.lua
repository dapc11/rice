local utils = require("core.utils")

utils.disabled_builtins()

utils.bootstrap()

utils.impatient()

local sources = { "core.globals", "core.plugins", "core.options", "core.keymaps", "core.custom-theme" }

for _, source in ipairs(sources) do
	local status_ok, fault = pcall(require, source)
	if not status_ok then
		error("Failed to load " .. source .. "\n\n" .. fault)
	end
end

utils.compiled()
