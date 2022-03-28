-- Fuzzy find
local function table_to_string(tbl)
	local result = "{"
	for k, v in pairs(tbl) do
		if type(k) == "string" then
			result = result .. '["' .. k .. '"]' .. "="
		end

		-- Check the value type
		if type(v) == "table" then
			result = result .. table_to_string(v)
		elseif type(v) == "boolean" then
			result = result .. tostring(v)
		else
			result = result .. '"' .. v .. '"'
		end
		result = result .. ","
	end
	-- Remove leading commas from the result
	if result ~= "" then
		result = result:sub(1, result:len() - 1)
	end
	return result .. "}"
end

local function get_find_files_source(path)
	local file = io.open(path, "r")
	local tbl = {}
	local i = 0
	if file then
		for line in file:lines() do
			i = i + 1
			tbl[i] = line
		end
		file:close()
	else
		tbl[0] = "~"
	end
	return table_to_string(tbl)
end

local opts = {}

local telescope_open_hidden = get_find_files_source(os.getenv("HOME") .. "/telescope_open_hidden.txt", opts)
local telescope_open = get_find_files_source(os.getenv("HOME") .. "/telescope_open.txt", opts)

map("n", "<leader>m", ':lua require("telescope.builtin").keymaps()<CR>', opts)
map("n", "<leader>h", ':lua require("telescope.builtin").oldfiles()<CR>', opts)
map("n", "<Leader>n", ':lua require("telescope.builtin").git_files()<CR>', opts)
map(
	"n",
	"<Leader>N",
	':lua require("telescope.builtin").git_files({git_command={"git","ls-files","--modified","--exclude-standard"}})<CR>',
	{}
)
map(
	"n",
	"<Leader>O",
	':lua require("telescope.builtin").find_files({hidden = true, no_ignore = true, previewer = false})<CR>',
	{}
)
map("n", "<Leader>o", ':lua require("telescope.builtin").find_files({previewer = false})<CR>', opts)
map(
	"n",
	"<Leader>f",
	':lua require("telescope.builtin").find_files({hidden = true, no_ignore = true, previewer = false, search_dirs = '
		.. telescope_open_hidden
		.. "})<CR>",
	{}
)
map(
	"n",
	"<leader><leader>",
	':lua require("telescope.builtin").live_grep({path_display={"truncate", shorten = {len = 3, exclude = {1,-1}}}})<CR>',
	{}
)
map("n", "<C-p>", ":Telescope projects<CR>", opts)
map("n", "<C-f>", ':lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>', opts)

-- Harpoon
map("n", "<A-m>", ":lua require('harpoon.mark').add_file()<CR>", opts)
map("n", "<A-l>", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", opts)
map("n", "<A-1>", ":lua require('harpoon.ui').nav_file(1)<CR>", opts)
map("n", "<A-2>", ":lua require('harpoon.ui').nav_file(2)<CR>", opts)
map("n", "<A-3>", ":lua require('harpoon.ui').nav_file(3)<CR>", opts)
map("n", "<A-4>", ":lua require('harpoon.ui').nav_file(4)<CR>", opts)

-- Fugitive
map("n", "<leader>gs", ":Git<CR>", opts)
map("n", "<leader>gl", ":Git log --stat<CR>", opts)

-- Misc
map("n", "<SPACE>", "<Nop>", opts)
map("n", "<F1>", "<Nop>", opts)

-- Clear highlight search
-- Use <C-L> to clear the highlighting of :set hlsearch.
map("n", "<C-l>", ':let @/ = ""<CR>', opts)

-- Profiling
map("n", "<Leader>zp", ":profile start nvim-profile.log | profile func * | profile file *", opts)

map("n", "ä", "<C-d>", opts)
map("n", "ö", "<C-u>", opts)
map("t", "<Esc>", "<C-\\><C-n>", opts)
-- Don't copy the replaced text after pasting in visual mode
map("v", "p", '"_dP', opts)
map("v", "c", '"_c', opts)
map("v", "c", '"_c', opts)

-- Requires gvim
-- Paste with shift+insert
map("n", "<Leader>Y", '"*y<CR>', opts)
map("n", "<Leader>P", '"*p<CR>', opts)
-- Paste with ctrl+v
map("n", "<Leader>y", '"+y<CR>', opts)
map("n", "<Leader>p", '"+p<CR>', opts)

-- Close buffer
map("n", "<Leader>q", "<c-w>q<CR>", opts)
map("n", "<Leader>Q", ":qa<CR>", opts)

-- Commandline
map("c", "<C-a>", "<Home>", opts)
map("c", "<C-e>", "<End>", opts)
map("c", "<M-Left>", "<S-Left>", opts)
map("c", "<M-Right>", "<S-Right>", opts)
map("c", "<M-BS>", "<C-W>", opts)
map("c", "<C-BS>", "<C-W>", opts)

-- Paste without overwrite default register
map("x", "p", "pgvy", opts)

-- Center search results
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

map("n", "m", ':<C-U>lua require("tsht").nodes()<CR>', opts)
map("v", "m", ':lua require("tsht").nodes()<CR>', opts)

map("n", "<C-Left>", "<C-W>h", opts)
map("n", "<C-Down>", "<C-W>j", opts)
map("n", "<C-Up>", "<C-W>k", opts)
map("n", "<C-Right>", "<C-W>l", opts)

-- Shift lines up and down
map("n", "<S-Down>", ":m .+1<CR>==", opts)
map("n", "<S-Up>", ":m .-2<CR>==", opts)
map("v", "<S-Down>", ":m '>+1<CR>gv=gv", opts)
map("v", "<S-Up>", ":m '<-2<CR>gv=gv", opts)

-- Gitsigns
map("n", "<Leader>gb", ":Gitsigns toggle_current_line_blame<CR>", opts)
map("n", "<Leader>gp", ":Gitsigns preview_hunk<CR>", opts)

-- Beginning and end of line
map("i", "<C-a>", "<home>", opts)
map("i", "<C-e>", "<end>", opts)

-- Control-V Paste in insert and command mode
map("i", "<C-v>", "<esc>pa", opts)
map("c", "<C-v>", "<C-r>0", opts)

-- Remap number increment to alt
map("n", "<A-a>", "<C-a>", opts)
map("v", "<A-a>", "<C-a>", opts)
map("n", "<A-x>", "<C-x>", opts)
map("v", "<A-x>", "<C-x>", opts)

vim.cmd([[
    " Sane navigation in command mode
    set wildcharm=<C-Z>
    cnoremap <expr> <up> wildmenumode() ? "\<left>" : "\<up>"
    cnoremap <expr> <down> wildmenumode() ? "\<right>" : "\<down>"
    cnoremap <expr> <left> wildmenumode() ? "\<up>" : "\<left>"
    cnoremap <expr> <right> wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"

    """""""" Clear quickfix list
    function ClearQuickfixList()
        call setqflist([])
    endfunction
    command! ClearQuickfixList call ClearQuickfixList()

    """""""" Echo syntax group
    function! SynGroup()
        let l:s = synID(line('.'), col('.'), 1)
        echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
    endfun
]])
map("n", "gm", ":call SynGroup()<CR>", opts)
map("n", "<leader>cc", ":ClearQuickfixList<CR>", opts)
map("x", "ga", ":EasyAlign<CR>", opts)
map("n", "ga", ":EasyAlign<CR>", opts)
map("n", "<leader>l", ":nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>", opts)
map(
	"n",
	"f",
	"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
	{}
)
map(
	"n",
	"F",
	"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
	{}
)
map(
	"o",
	"f",
	"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>",
	{}
)
map(
	"o",
	"F",
	"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>",
	{}
)
map(
	"",
	"t",
	"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
	{}
)
map(
	"",
	"T",
	"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
	{}
)

map("n", "<C-t>", ":NvimTreeToggle<CR>", opts)
map("n", "<C-e>", "<cmd>AerialToggle<CR>", opts)
map("n", "<leader>cd", "<cmd>lua vim.diagnostic.disable()<CR>", opts)
map("n", "<leader>ce", "<cmd>lua vim.diagnostic.enable()<CR>", opts)

map("i", "<C-E>", "<Plug>luasnip-next-choice", opts)
map("s", "<C-E>", "<Plug>luasnip-next-choice", opts)
