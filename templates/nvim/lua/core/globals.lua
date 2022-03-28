function _G.map(mode, lhs, rhs, opts)
	local finalRhs = ""
	local callback = nil
	if type(rhs) == "string" then
		finalRhs = rhs
	else
		callback = rhs
	end

	opts = vim.tbl_extend("keep", opts or {}, {
		noremap = true,
		silent = true,
		expr = false,
		callback = callback,
	})

	vim.api.nvim_set_keymap(mode, lhs, finalRhs, opts)
end

function _G.au(event, filetype, action)
	vim.cmd("au" .. " " .. event .. " " .. filetype .. " " .. action)
end

function _G.hi(group, options)
	vim.cmd(
		"hi "
			.. group
			.. " "
			.. "cterm="
			.. (options.cterm or "none")
			.. " "
			.. "ctermfg="
			.. (options.ctermfg or "none")
			.. " "
			.. "ctermbg="
			.. (options.ctermbg or "none")
			.. " "
			.. "gui="
			.. (options.gui or "none")
			.. " "
			.. "guifg="
			.. (options.guifg or "none")
			.. " "
			.. "guibg="
			.. (options.guibg or "none")
	)
end
