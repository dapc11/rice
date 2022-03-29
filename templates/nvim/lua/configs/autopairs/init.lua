local M = {}

function M.config()
	local status_ok, npairs = pcall(require, "nvim-autopairs")
	if not status_ok then
		return
	end

	npairs.setup({
		disable_in_visualblock = true,
		check_ts = true,
		disable_filetype = { "TelescopePrompt", "spectre_panel" },
		fast_wrap = {
			map = "<M-e>",
			chars = { "{", "[", "(", '"', "'", " " },
			pattern = string.gsub([[ [% %'%"%)%>%]%)%}%,] ]], "%s+", ""),
			offset = -1, -- Offset from pattern match
			end_key = "$",
			keys = "qwertyuiopzxcvbnmasdfghjkl",
			check_comma = true,
			highlight = "PmenuSel",
			highlight_grey = "LineNr",
		},
	})
end

return M
