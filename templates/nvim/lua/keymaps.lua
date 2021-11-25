local map = function(key)
    -- get the extra options
    local opts = {noremap = true}
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

-- Harpoon
map {'n', '<C-a>', ":lua require('harpoon.mark').add_file()<CR>"}
map {'n', '<A-a>', ":lua require('harpoon.ui').toggle_quick_menu()<CR>"}
map {'n', '<A-q>', ":lua require('harpoon.ui').nav_file(1)<CR>"}
map {'n', '<A-w>', ":lua require('harpoon.ui').nav_file(2)<CR>"}
map {'n', '<A-e>', ":lua require('harpoon.ui').nav_file(3)<CR>"}
map {'n', '<A-r>', ":lua require('harpoon.ui').nav_file(4)<CR>"}

-- Nvim lint
map {silent = true, 'n', '<leader>cl', ":lua require('lint').try_lint()<CR>"}

-- Fugitive
map {'n', '<leader>gs', ':Git<CR>'}

-- Misc
-- Use <C-L> to clear the highlighting of :set hlsearch.
map {silent = true, 'n', '<C-l>', ':let @/ = ""<CR>'}
map {'n', '<Leader>zp', ':profile start nvim-profile.log \\| profile func * \\| profile file *'}


-- TODO
map {'n', '<SPACE>', '<Nop>'}
vim.g.mapleader = " "

--map ä <C-d>
--map ö <C-u>
--map ga <Nop>
--map ¨ <C-^>

--inoremap <C-Space> <C-x><C-n>
--nnoremap <silent> <A-left> :bp<CR>
--nnoremap <silent> <A-right> :bn<CR>

--" Requires gvim
--" paste with shift+insert
--noremap <Leader>Y "*y<CR>
--noremap <Leader>P "*p<CR>
--" paste with ctrl+v
--noremap <Leader>y "+y<CR>
--noremap <Leader>p "+p<CR>

--" Close buffer
map {'n', '<Leader>q', '<c-w>q<CR>'}
map {'n', '<Leader>Q', ':qa<CR>'}

--" Commandline
map {'c', '<C-a>', '<Home>'}
map {'c', '<C-e>', '<End>'}
map {'c', '<M-Left>', '<S-Left>'}
map {'c', '<M-Right>', '<S-Right>'}
map {'c', '<M-BS>', '<C-W>'}
map {'c', '<C-BS>', '<C-W>'}

--" Paste over select and keep register
--vnoremap <leader>p "_dP

--" :e sane mappings
--set wildcharm=<C-Z>
--cnoremap <expr> <up> wildmenumode() ? "\<left>" : "\<up>"
--cnoremap <expr> <down> wildmenumode() ? "\<right>" : "\<down>"
--cnoremap <expr> <left> wildmenumode() ? "\<up>" : "\<left>"
--cnoremap <expr> <right> wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"

--" Navigate errors
map {'n', '<C-n>', ':cn<CR>'}
map {'n', '<C-b>', ':cp<CR>'}

--" Paste without overwrite default register
map {'x', 'p', 'pgvy'}

--" center search results
map {'n', 'n', 'nzzzv'}
map {'n', 'N', 'Nzzzv'}

--" set moving between windows to ctrl+arrows
--function! WinMove(key)
--    let t:curwin = winnr()
--    exec "wincmd ".a:key
--    if (t:curwin == winnr())
--        if (match(a:key,'[jk]'))
--            wincmd v
--        else
--            wincmd s
--        endif
--        exec "wincmd ".a:key
--    endif
--endfunction

--nnoremap <silent> <C-Left> :call WinMove('h')<CR>
--nnoremap <silent> <C-Down> :call WinMove('j')<CR>
--nnoremap <silent> <C-Up> :call WinMove('k')<CR>
--nnoremap <silent> <C-Right> :call WinMove('l')<CR>

map {'n', '<S-Down>', ':m .+1<CR>=='}
map {'n', '<S-Up>', ':m .-2<CR>=='}
map {'v', '<S-Down>', ":m '>+1<CR>gv=gv"}
map {'v', '<S-Up>', ":m '<-2<CR>gv=gv"}

--" Gitsigns
map {'n', '<Leader>gb', ':Gitsigns toggle_current_line_blame<CR>'}
map {'n', '<Leader>gp', ':Gitsigns preview_hunk<CR>'}
map {'n', '<Leader>grh', ':Gitsigns reset_hunk<CR>'}
map {'n', '<Leader>grb', ':Gitsigns reset_buffer<CR>'}

map {'n', '<C-s>', ':w<cr>'}
