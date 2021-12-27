local g, s = vim.g, vim.opt
s.tabstop        = 4
s.softtabstop    = 4
s.shiftwidth     = 4               -- 4 spaces
s.shiftround     = true            -- Round tabs to multiplier of shiftwicth
s.smartindent    = true
s.expandtab      = true            -- In Insert mode: Use the appropriate number of spaces to insert a tab
s.relativenumber = true            -- relative line numbers to current line
s.cursorline     = true            -- Highlgiht cursor line
s.hlsearch       = true            -- Highlight search
s.hidden         = true
s.errorbells     = false           -- No sound on error
s.nu             = true            -- Line numbers
s.wrap           = false
s.swapfile       = false
s.backup         = false
s.undodir        = os.getenv("HOME") .. "/.vim/undodir"
s.undofile       = true
s.incsearch      = true            -- Evolve search as I write
s.termguicolors  = true            -- Make colorscheme work
s.scrolloff      = 8               -- Start scroll when n lines from screen edge
s.showmode       = false
s.colorcolumn    = "100"           -- Dont go further
s.updatetime     = 50              -- Short time to combo key strokes
s.mouse          = "a"             -- Enable mouse
s.autoread       = true
s.completeopt    = "menu,menuone,noselect"
s.shortmess:append("c")
s.clipboard:append("unnamedplus")   -- System clipboard

-- Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
s.splitbelow = true
s.splitright = true
g["UltiSnipsExpandTrigger"] = "<tab>"
g["UltiSnipsJumpForwardTrigger"] = "<tab>"
g["UltiSnipsJumpBackwardTrigger"] = "<s-tab>"
g["UltiSnipsSnippetDirectories"] = {"~/.config/nvim/UltiSnips/"}

g["indent_blankline_use_treesitter"] = true
g["indent_blankline_show_first_indent_level"] = true
g["indent_blankline_filetype_exclude"] = {"help"}
g["indentLine_setConceal"] = 0

g["rooter_patterns"] = {"setup.cfg", ".git", "pom.xml", "Makefile", "*.sln", "build/env.sh"}
-- vim.g["rooter_change_directory_for_non_project_files"] = "home"

g["python3_host_prog"] = "~/dev/bin/python3"

-- Not load with default plugin.
g["did_load_filetypes"] = 1
