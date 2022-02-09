local g, s = vim.g, vim.opt
s.tabstop = 4
s.softtabstop = 4
s.shiftwidth = 4 -- 4 spaces
s.shiftround = true -- Round tabs to multiplier of shiftwicth
s.smartindent = true
s.ignorecase = true
s.expandtab = true -- In Insert mode: Use the appropriate number of spaces to insert a tab
s.relativenumber = true -- relative line numbers to current line
s.cursorline = true -- Highlgiht cursor line
s.hlsearch = true -- Highlight search
s.hidden = true
s.errorbells = false -- No sound on error
s.nu = true -- Line numbers
s.wrap = false
s.swapfile = false
s.backup = false
s.undodir = os.getenv("HOME") .. "/.vim/undodir"
s.undofile = true
s.incsearch = true -- Evolve search as I write
s.termguicolors = true -- Make colorscheme work
s.scrolloff = 8 -- Start scroll when n lines from screen edge
s.showmode = false
s.colorcolumn = "100" -- Dont go further
s.updatetime = 50 -- Short time to combo key strokes
s.mouse = "a" -- Enable mouse
s.autoread = true
s.completeopt = "menu,menuone,noselect"
s.shortmess:append("c")
s.clipboard:append("unnamedplus") -- System clipboard

-- Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
s.splitbelow = true
s.splitright = true

g["indent_blankline_use_treesitter"] = true
g["indent_blankline_show_first_indent_level"] = true
g["indent_blankline_filetype_exclude"] = {"help"}
g["indentLine_setConceal"] = 0

-- g["rooter_patterns"] = {"setup.cfg", ".git", "pom.xml", "Makefile", "*.sln", "build/env.sh"}
-- vim.g["rooter_change_directory_for_non_project_files"] = "home"

-- g["python3_host_prog"] = "~/dev/bin/python3"
-- g["python_host_prog"] = "~/dev/bin/python"

-- Not load with default plugin.
g["did_load_filetypes"] = 1
vim.cmd [[
set path+=**
nnoremap <SPACE> <Nop>
let mapleader =" "

function! HighlightTodo()
match none
match Error /TODO/
endfunc

set background=dark
colorscheme dapc11

augroup dapc
autocmd!
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline
autocmd BufNewFile,BufRead *.tpl set filetype=gotmpl
autocmd BufNewFile,BufRead *.yaml if search('{{.*}}', 'nw') | setlocal filetype=gotmpl | endif
" Yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" autocmd BufRead * lua require('lint').try_lint()
" autocmd BufWrite * lua require('lint').try_lint()
autocmd BufReadPost,BufNewFile * :call HighlightTodo()
augroup END

au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=250, on_visual=true}

sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticLineNrError
sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticLineNrWarn
sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticLineNrInfo
sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticLineNrHint
]]

local signs = {
    {
        name = "DiagnosticSignError",
        text = "",
        type = "Error"
    }, {
        name = "DiagnosticSignWarn",
        text = "",
        type = "Warn"
    }, {
        name = "DiagnosticSignHint",
        text = "",
        type = "Hint"
    }, {
        name = "DiagnosticSignInfo",
        text = "",
        type = "Info"
    }
}

for _, sign in ipairs(signs) do
    local hl = "DiagnosticLineNr" .. sign.type
    vim.fn.sign_define(sign.name, {
        texthl = sign.name,
        text = sign.text,
        numhl = hl
    })
end
