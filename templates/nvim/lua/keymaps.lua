local map = function(key)
    -- get the extra options
    local opts = {noremap = true, silent = true}
    for i, v in pairs(key) do
        if type(i) == 'string' then opts[i] = v end
    end

    -- basic support for buffer-scoped keybindings
    local buffer = opts.buffer
    opts.buffer = nil

    if buffer then
        vim.api.nvim_buf_set_keymap(0, key[1], key[2], key[3], opts)
    else
        vim.api.nvim_set_keymap(key[1], key[2], key[3], opts)
    end
end

-- Resize buffers
map {'n', '<C-w>+', ':resize +8<CR>'}
map {'n', '<C-w>-', ':resize -8<CR>'}
map {'n', '<C-w><', ':vertical:resize -8<CR>'}
map {'n', '<C-w>>', ':vertical:resize +8<CR>'}

-- Fuzzy find
map {'n', '<leader>b', ':Telescope buffers<CR>'}
map {'n', '<leader>m', ':Telescope keymaps<CR>'}
map {'n', '<leader>h', ':Telescope oldfiles<CR>'}
map {'n', '<Leader>n', ':Telescope git_files<CR>'}
map {'n', '<leader>ff', ':Telescope find_files<CR>'}
map {'n', '<leader><leader>', ':Telescope live_grep<CR>'}
map {'n', '<C-f>', ':Telescope current_buffer_fuzzy_find<CR>'}
map {'n', '<leader>fa', ':Telescope find_files hidden=true<CR>'}
vim.cmd [[
    command! -nargs=? -complete=dir AD call fzf#run(fzf#wrap({'source': 'rg ~/repos ~/personal_repos --max-depth 2 --hidden --files --null | xargs -0 dirname | sort | uniq '.expand(<q-args>)}))
    command! -nargs=? -complete=dir AF call fzf#run(fzf#wrap({'source': 'rg --no-heading --files ~/ '.expand(<q-args>)}))
    command! -nargs=? -complete=dir AFF call fzf#run(fzf#wrap({'source': 'rg --no-heading --files --hidden ~/ '.expand(<q-args>)}))
    command! -bang ProjectFiles call fzf#vim#files('~/repos', <bang>0)
]]
map {'n', '<leader>d', ':AD<CR>'}
map {'n', '<Leader>o', ':AF<CR>'}
map {'n', '<Leader>O', ':AFF<CR>'}
map {'n', '<C-f>', ':BLines<cr>'}
map {'n', '<C-p>', ':ProjectFiles<CR>'}
map {'n', '<leader>cd', ':lua require"telescope".extensions.zoxide.list{}<CR>'}

-- Harpoon
map {'n', '<F1>', ":lua require('harpoon.term').gotoTerminal(1)<CR>"}
map {'n', '<F2>', ":lua require('harpoon.term').gotoTerminal(2)<CR>"}
map {'n', '<A-a>', ":lua require('harpoon.mark').add_file()<CR>"}
map {'n', '<A-l>', ":lua require('harpoon.ui').toggle_quick_menu()<CR>"}
map {'n', '<A-1>', ":lua require('harpoon.ui').nav_file(1)<CR>"}
map {'n', '<A-2>', ":lua require('harpoon.ui').nav_file(2)<CR>"}
map {'n', '<A-3>', ":lua require('harpoon.ui').nav_file(3)<CR>"}
map {'n', '<A-4>', ":lua require('harpoon.ui').nav_file(4)<CR>"}

-- Nvim lint
map {'n', '<leader>cl', ":lua require('lint').try_lint()<CR>"}

-- Fugitive
map {'n', '<leader>gs', ':Git<CR>'}

-- Misc
-- Use <C-L> to clear the highlighting of :set hlsearch.
map {'n', '<SPACE>', '<Nop>'}
vim.g.mapleader = " "

-- Clear highlight search
map {silent = true, 'n', '<C-l>', ':let @/ = ""<CR>'}
map {'n', '<Leader>zp', ':profile start nvim-profile.log \\| profile func * \\| profile file *'}

map {'n', 'ä', '<C-d>'}
map {'n', 'ö', '<C-u>'}
map {'n', '¨', '<C-^>'}
map {'t', '<Esc>', '<C-\\><C-n>'}
-- Don't copy the replaced text after pasting in visual mode
map {"v", "p", '"_dP'}

map {'n', '<C-Space>', '<C-x><C-n>'}
map {'n', '<A-left>', ':bp<CR>'}
map {'n', '<A-right>', ':bn<CR>'}

--" Requires gvim
--" paste with shift+insert
map {'n', '<Leader>Y', '"*y<CR>'}
map {'n', '<Leader>P', '"*p<CR>'}
--" paste with ctrl+v
map {'n', '<Leader>y', '"+y<CR>'}
map {'n', '<Leader>p', '"+p<CR>'}

-- Close buffer
map {'n', '<Leader>q', '<c-w>q<CR>'}
map {'n', '<Leader>Q', ':qa<CR>'}

-- Commandline
map {'c', '<C-a>', '<Home>'}
map {'c', '<C-e>', '<End>'}
map {'c', '<M-Left>', '<S-Left>'}
map {'c', '<M-Right>', '<S-Right>'}
map {'c', '<M-BS>', '<C-W>'}
map {'c', '<C-BS>', '<C-W>'}

-- Paste over select and keep register
map {'v', '<leader>p', '"_dP'}

--" Navigate errors
map {'n', '<C-n>', ':cn<CR>'}
map {'n', '<C-b>', ':cp<CR>'}

--" Paste without overwrite default register
map {'x', 'p', 'pgvy'}

--" center search results
map {'n', 'n', 'nzzzv'}
map {'n', 'N', 'Nzzzv'}

-- set moving between windows to ctrl+arrows
vim.cmd[[
    function! WinMove(key)
        let t:curwin = winnr()
        exec "wincmd ".a:key
        if (t:curwin == winnr())
            if (match(a:key,'[jk]'))
                wincmd v
            else
                wincmd s
            endif
            exec "wincmd ".a:key
        endif
    endfunction
]]

map {'n', '<C-Left>', ":call WinMove('h')<CR>"}
map {'n', '<C-Down>', ":call WinMove('j')<CR>"}
map {'n', '<C-Up>', ":call WinMove('k')<CR>"}
map {'n', '<C-Right>', ":call WinMove('l')<CR>"}

-- Shift lines up and down
map {'n', '<S-Down>', ':m .+1<CR>=='}
map {'n', '<S-Up>', ':m .-2<CR>=='}
map {'v', '<S-Down>', ":m '>+1<CR>gv=gv"}
map {'v', '<S-Up>', ":m '<-2<CR>gv=gv"}

-- Gitsigns
map {'n', '<Leader>gb', ':Gitsigns toggle_current_line_blame<CR>'}
map {'n', '<Leader>gp', ':Gitsigns preview_hunk<CR>'}
map {'n', '<Leader>grh', ':Gitsigns reset_hunk<CR>'}
map {'n', '<Leader>grb', ':Gitsigns reset_buffer<CR>'}

map {'n', '<C-s>', ':w<cr>'}

-- Beginning and end of line
map {noremap = false, 'i', '<C-a>', '<home>'}
map {noremap = false, 'i', '<C-e>', '<end>'}
map {noremap = false, 'c', '<C-a>', '<home>'}
map {noremap = false, 'c', '<C-e>', '<end>'}

-- Control-V Paste in insert and command mode
map {noremap = false, 'i', '<C-V>', '<esc>pa'}
map {noremap = false, 'c', '<C-V>', '<C-r>0'}
map {'n', '<C-e>', ':NvimTreeToggle<CR>'}


-- Zettelkasten
map {'n', '<leader>z', ':lua require("telekasten").panel()<CR>'}
map {'n', '<leader>zf', ':lua require("telekasten").find_notes()<CR>'}
map {'n', '<leader>zd', ':lua require("telekasten").find_daily_notes()<CR>'}
map {'n', '<leader>zg', ':lua require("telekasten").search_notes()<CR>'}
map {'n', '<leader>zz', ':lua require("telekasten").follow_link()<CR>'}
map {'n', '<leader>zT', ':lua require("telekasten").goto_today()<CR>'}
map {'n', '<leader>zW', ':lua require("telekasten").goto_thisweek()<CR>'}
map {'n', '<leader>zw', ':lua require("telekasten").find_weekly_notes()<CR>'}
map {'n', '<leader>zn', ':lua require("telekasten").new_note()<CR>'}
map {'n', '<leader>zN', ':lua require("telekasten").new_templated_note()<CR>'}
map {'n', '<leader>zy', ':lua require("telekasten").yank_notelink()<CR>'}
map {'n', '<leader>zc', ':lua require("telekasten").show_calendar()<CR>'}
map {'n', '<leader>zC', ':CalendarT<CR>'}
map {'n', '<leader>zi', ':lua require("telekasten").paste_img_and_link()<CR>'}
map {'n', '<leader>zt', ':lua require("telekasten").toggle_todo()<CR>'}
map {'n', '<leader>zb', ':lua require("telekasten").show_backlinks()<CR>'}
map {'n', '<leader>zF', ':lua require("telekasten").find_friends()<CR>'}
map {'n', '<leader>zI', ':lua require("telekasten").insert_img_link({ i=true })<CR>'}
map {'n', '<leader>zp', ':lua require("telekasten").preview_img()<CR>'}
map {'n', '<leader>zm', ':lua require("telekasten").browse_media()<CR>'}
map {'i', '[[', '<ESC>:lua require("telekasten").insert_link({ i=true })<CR>'}
map {'i', '<C-z>t', '<ESC>:lua require("telekasten").toggle_todo({ i=true })<CR>'}


-- Clean quickfix list
vim.cmd[[
    function ClearQuickfixList()
        call setqflist([])
    endfunction
    command! ClearQuickfixList call ClearQuickfixList()
]]
map {'n', '<leader>cc', ':ClearQuickfixList<CR>'}

-- Sane navigation in command mode
vim.cmd[[
    set wildcharm=<C-Z>
    cnoremap <expr> <up> wildmenumode() ? "\<left>" : "\<up>"
    cnoremap <expr> <down> wildmenumode() ? "\<right>" : "\<down>"
    cnoremap <expr> <left> wildmenumode() ? "\<up>" : "\<left>"
    cnoremap <expr> <right> wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"
]]
vim.cmd[[
    function! s:split(expr) abort
    let lines = split(execute(a:expr, 'silent'), "[\n\r]")
    let name = printf('capture://%s', a:expr)

    if bufexists(name) == v:true
        execute 'bwipeout' bufnr(name)
    end

    execute 'botright' 'new' name

    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal filetype=vim

    call append(line('$'), lines)
    endfunction

    function! s:fzf(expr) abort
    let lines = split(execute(a:expr, 'silent'), "[\n\r]")
    return fzf#run({'source': lines,  'options': '--tiebreak begin --ansi --header-lines 1'})
    endfunction

    function s:capture(expr, bang) abort
        if a:bang
            call s:fzf(a:expr)
        else
            call s:split(a:expr)
            endif
            endfunction

    command! -nargs=1 -bang -complete=command P call s:capture(<q-args>, <bang>0)
]]

function toggle_zoom()
    if zoomed then
        vim.cmd 'wincmd ='
        zoomed = false
    else
        vim.cmd 'resize'
        vim.cmd 'vertical resize'
        zoomed = true
    end
end
map {'n', '<C-z>', '<cmd>lua toggle_zoom()<CR>'}

-- Remap number increment to alt
map {'n', '<A-a>', '<C-a>'}
map {'v', '<A-a>', '<C-a>'}
map {'n', '<A-x>', '<C-x>'}
map {'v', '<A-x>', '<C-x>'}
