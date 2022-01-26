local map = function(key)
    -- get the extra options
    local opts = {
        noremap = true,
        silent = true
    }
    for i, v in pairs(key) do
        if type(i) == 'string' then
            opts[i] = v
        end
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
function table_to_string(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        if type(k) == "string" then
            result = result.."[\""..k.."\"]".."="
        end

        -- Check the value type
        if type(v) == "table" then
            result = result..table_to_string(v)
        elseif type(v) == "boolean" then
            result = result..tostring(v)
        else
            result = result.."\""..v.."\""
        end
        result = result..","
    end
    -- Remove leading commas from the result
    if result ~= "" then
        result = result:sub(1, result:len()-1)
    end
    return result.."}"
end

function get_find_files_source(path)
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

local telescope_open_hidden = get_find_files_source(os.getenv("HOME") .. "/telescope_open_hidden.txt")
local telescope_open = get_find_files_source(os.getenv("HOME") .. "/telescope_open.txt")

map {'n', '<leader>b', ':lua require("telescope.builtin").buffers()<CR>'}
map {'n', '<leader>m', ':lua require("telescope.builtin").keymaps()<CR>'}
map {'n', '<leader>h', ':lua require("telescope.builtin").oldfiles()<CR>'}
map {'n', '<Leader>n', ':lua require("telescope.builtin").git_files()<CR>'}
map {'n', '<Leader>N', ':lua require("telescope.builtin").git_files({git_command={"git","ls-files","--modified","--exclude-standard"}})<CR>'}
map {'n', '<Leader>o', ':lua require("telescope.builtin").find_files({previewer = false, search_dirs = ' .. telescope_open .. '})<CR>'}
map {'n', '<Leader>O', ':lua require("telescope.builtin").find_files({hidden = true, no_ignore = true, previewer = false, search_dirs = ' .. telescope_open_hidden .. '})<CR>'}
map {'n', '<leader><leader>', ':lua require("telescope.builtin").live_grep({path_display={"truncate", shorten = {len = 3, exclude = {1,-1}}}})<CR>'}
map {'n', '<C-p>', ':lua require("telescope.builtin").find_files()<CR>'}
map {'n', '<C-f>', ':lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>'}
vim.cmd [[
command! -nargs=? -complete=dir AD call fzf#run(fzf#wrap({'source': 'rg ~/repos ~/personal_repos --max-depth 2 --hidden --files --null | xargs -0 dirname | sort | uniq '.expand(<q-args>)}))
]]
map {'n', '<leader>d', ':AD<CR>'}
map {'n', '<leader>cd', ':lua require"telescope".extensions.zoxide.list{}<CR>'}

-- Harpoon
map {'n', '<A-m>', ":lua require('harpoon.mark').add_file()<CR>"}
map {'n', '<A-l>', ":lua require('harpoon.ui').toggle_quick_menu()<CR>"}
map {'n', '<A-1>', ":lua require('harpoon.ui').nav_file(1)<CR>"}
map {'n', '<A-2>', ":lua require('harpoon.ui').nav_file(2)<CR>"}
map {'n', '<A-3>', ":lua require('harpoon.ui').nav_file(3)<CR>"}
map {'n', '<A-4>', ":lua require('harpoon.ui').nav_file(4)<CR>"}

-- Nvim lint
map {'n', '<leader>cl', ":lua require('lint').try_lint()<CR>"}

-- Fugitive
map {'n', '<leader>gs', ':Git<CR>'}
map {'n', '<leader>gl', ':Git log --stat<CR>'}

-- Misc
map {'n', '<SPACE>', '<Nop>'}
map {'n', '<F1>', '<Nop>'}
vim.g.mapleader = " "

-- Clear highlight search
-- Use <C-L> to clear the highlighting of :set hlsearch.
map {
    silent = true,
    'n',
    '<C-l>',
    ':let @/ = ""<CR>'
}
map {'n', '<Leader>zp', ':profile start nvim-profile.log | profile func * | profile file *'}

map {'n', 'ä', '<C-d>'}
map {'n', 'ö', '<C-u>'}
map {'n', '¨', '<C-^>'}
map {'t', '<Esc>', '<C-\\><C-n>'}
-- Don't copy the replaced text after pasting in visual mode
map {"v", "p", '"_dP'}

map {'n', '<C-Space>', '<C-x><C-n>'}
map {'n', '<A-left>', ':bp<CR>'}
map {'n', '<A-right>', ':bn<CR>'}

-- " Requires gvim
-- " paste with shift+insert
map {'n', '<Leader>Y', '"*y<CR>'}
map {'n', '<Leader>P', '"*p<CR>'}
-- " paste with ctrl+v
map {'n', '<Leader>y', '"+y<CR>'}
map {'n', '<Leader>p', '"+p<CR>'}

-- Close buffer
map {'n', '<Leader>q', '<c-w>q<CR>'}
map {'n', '<Leader>Q', ':qa<CR>'}
map {'n', '<C-q>', ':bdelete<CR>'}

-- Commandline
map {'c', '<C-a>', '<Home>'}
map {'c', '<C-e>', '<End>'}
map {'c', '<M-Left>', '<S-Left>'}
map {'c', '<M-Right>', '<S-Right>'}
map {'c', '<M-BS>', '<C-W>'}
map {'c', '<C-BS>', '<C-W>'}

-- Paste over select and keep register
map {'v', '<leader>p', '"_dP'}

-- " Navigate errors
map {'n', '<C-n>', ':cn<CR>'}
map {'n', '<C-b>', ':cp<CR>'}

-- " Paste without overwrite default register
map {'x', 'p', 'pgvy'}

-- " center search results
map {'n', 'n', 'nzzzv'}
map {'n', 'N', 'Nzzzv'}

-- set moving between windows to ctrl+telescope_openows
vim.cmd [[
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
        map {
            noremap = false,
            'i',
            '<C-a>',
            '<home>'
        }
        map {
            noremap = false,
            'i',
            '<C-e>',
            '<end>'
        }
        map {
            noremap = false,
            'c',
            '<C-a>',
            '<home>'
        }
        map {
            noremap = false,
            'c',
            '<C-e>',
            '<end>'
        }

        -- Control-V Paste in insert and command mode
        map {
            noremap = false,
            'i',
            '<C-V>',
            '<esc>pa'
        }
        map {
            noremap = false,
            'c',
            '<C-V>',
            '<C-r>0'
        }
        map {'n', '<C-t>', ':NvimTreeToggle<CR>'}

        -- Zettelkasten
        map {'n', '<leader>z', ':lua require("telekasten").panel()<CR>'}
        map {'n', '<leader>zf', ':lua require("telekasten").find_notes()<CR>'}
        map {'n', '<leader>zg', ':lua require("telekasten").search_notes()<CR>'}
        map {'n', '<leader>zn', ':lua require("telekasten").new_note()<CR>'}

        -- Clean quickfix list
        vim.cmd [[
        function ClearQuickfixList()
            call setqflist([])
            endfunction
            command! ClearQuickfixList call ClearQuickfixList()
            ]]
            map {'n', '<leader>cc', ':ClearQuickfixList<CR>'}

            -- Sane navigation in command mode
            vim.cmd [[
            set wildcharm=<C-Z>
            cnoremap <expr> <up> wildmenumode() ? "\<left>" : "\<up>"
            cnoremap <expr> <down> wildmenumode() ? "\<right>" : "\<down>"
            cnoremap <expr> <left> wildmenumode() ? "\<up>" : "\<left>"
            cnoremap <expr> <right> wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"
            ]]
            vim.cmd [[
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

                    -- Remap number increment to alt
                    map {'n', '<A-a>', '<C-a>'}
                    map {'v', '<A-a>', '<C-a>'}
                    map {'n', '<A-x>', '<C-x>'}
                    map {'v', '<A-x>', '<C-x>'}
                    -- These commands will move the current buffer backwards or forwards in the bufferline
                    -- map {'n', '<Tab>', ':BufferLineCycleNext<CR>'}
                    -- map {'n', '<C-Tab>', ':BufferLineCyclePrev<CR>'}
                    -- map {'n', '<S-Tab>', ':BufferLineMoveNext<CR>'}
                    -- map {'n', '<S-C-Tab>', ':BufferLineMovePrev<CR>'}
