local set = vim.opt
local set_global = vim.g

set.tabstop        = 4
set.softtabstop    = 4
set.shiftwidth     = 4               -- 4 spaces
set.shiftround     = true            -- Round tabs to multiplier of shiftwicth
set.smartindent    = true
set.expandtab      = true            -- In Insert mode: Use the appropriate number of spaces to insert a tab
set.relativenumber = true            -- relative line numbers to current line
set.cursorline     = true            -- Highlgiht cursor line
set.hlsearch       = true            -- Highlight search
set.hidden         = true
set.errorbells     = false           -- No sound on error
set.nu             = true            -- Line numbers
set.wrap           = false
set.swapfile       = false
set.backup         = false
set.undodir        = "~/.vim/undodir"
set.undofile       = true
set.incsearch      = true            -- Evolve search as I write
set.termguicolors  = true            -- Make colorscheme work
set.scrolloff      = 8               -- Start scroll when n lines from screen edge
set.showmode       = false
set.colorcolumn    = "100"           -- Dont go further
set.updatetime     = 50              -- Short time to combo key strokes
set.mouse          = "a"             -- Enable mouse
set.autoread       = true
set.completeopt    = "menu,menuone,noselect"
set.shortmess:append("c")
set.clipboard:append("unnamedplus")   -- System clipboard

-- Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
set.splitbelow = true
set.splitright = true

set_global["UltiSnipsExpandTrigger"] = "<tab>"
set_global["UltiSnipsJumpForwardTrigger"] = "<tab>"
set_global["UltiSnipsJumpBackwardTrigger"] = "<s-tab>"
set_global["UltiSnipsSnippetDirectories"] = {"~/.config/nvim/UltiSnips/"}

set_global["indent_blankline_use_treesitter"] = true
set_global["indent_blankline_show_first_indent_level"] = true
set_global["indent_blankline_filetype_exclude"] = {"help"}
set_global["indentLine_setConceal"] = 0

set_global["rooter_patterns"] = {"setup.cfg", ".git", "pom.xml", "Makefile", "*.sln", "build/env.sh"}
-- vim.g["rooter_change_directory_for_non_project_files"] = "home"

set_global["python3_host_prog"] = "~/dev/bin/python3"
