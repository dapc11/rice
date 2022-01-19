vim.opt.list = true
vim.cmd [[highlight IndentBlanklineChar guifg={{base02}} gui=nocombine]]

require("indent_blankline").setup {
    show_end_of_line = false,
    space_char_blankline = " "
}