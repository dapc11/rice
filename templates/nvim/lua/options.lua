vim.opt.tabstop        = 4
vim.opt.softtabstop    = 4
vim.opt.shiftwidth     = 4               -- 4 spaces
vim.opt.shiftround     = true            -- Round tabs to multiplier of shiftwicth
vim.opt.smartindent    = true
vim.opt.expandtab      = true            -- In Insert mode: Use the appropriate number of spaces to insert a tab
vim.opt.relativenumber = true            -- relative line numbers to current line
vim.opt.cursorline     = true            -- Highlgiht cursor line
vim.opt.hlsearch       = true            -- Highlight search
vim.opt.hidden         = true
vim.opt.errorbells     = false           -- No sound on error
vim.opt.nu             = true            -- Line numbers
vim.opt.wrap           = false
vim.opt.swapfile       = false
vim.opt.backup         = false
vim.opt.undodir        = "~/.vim/undodir"
vim.opt.undofile       = true
vim.opt.incsearch      = true            -- Evolve search as I write
vim.opt.termguicolors  = true            -- Make colorscheme work
vim.opt.scrolloff      = 8               -- Start scroll when n lines from screen edge
vim.opt.showmode       = false
vim.opt.colorcolumn    = "100"           -- Dont go further
vim.opt.updatetime     = 50              -- Short time to combo key strokes
vim.opt.mouse          = "a"             -- Enable mouse
vim.opt.autoread       = true
vim.opt.completeopt    = "menu,menuone,noselect"
vim.opt.shortmess:append("c")
vim.opt.clipboard:append("unnamedplus")   -- System clipboard

-- Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.g["UltiSnipsExpandTrigger"] = "<tab>"
vim.g["UltiSnipsJumpForwardTrigger"] = "<tab>"
vim.g["UltiSnipsJumpBackwardTrigger"] = "<s-tab>"
vim.g["UltiSnipsSnippetDirectories"] = {"~/.config/nvim/UltiSnips"}

vim.g["indent_blankline_use_treesitter"] = true
vim.g["indent_blankline_show_first_indent_level"] = true
vim.g["indent_blankline_filetype_exclude"] = {"help"}
vim.g["indentLine_setConceal"] = 0

vim.g["rooter_patterns"] = {"setup.cfg", ".git", "pom.xml", "Makefile", "*.sln", "build/env.sh"}
-- vim.g["rooter_change_directory_for_non_project_files"] = "home"

vim.g["python3_host_prog"] = "~/dev/bin/python3"
