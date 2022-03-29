local M = {}

function M.config()
	local status_ok, npairs = pcall(require, "nvim-autopairs")
	if not status_ok then
		return
	end

	npairs.setup({
		disable_in_visualblock = true,
		check_ts = false,
		disable_filetype = { "TelescopePrompt", "spectre_panel" },
		fast_wrap = {
			map = "<M-e>",
			highlight = "PmenuSel",
			highlight_grey = "LineNr",
		},
	})
end

return M
