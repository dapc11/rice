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
map {noremap = false, 'n', '<C-a>', ":lua require('harpoon.mark').add_file()<CR>"}
map {noremap = false, 'n', '<A-a>', ":lua require('harpoon.ui').toggle_quick_menu()<CR>"}
map {noremap = false, 'n', '<A-q>', ":lua require('harpoon.ui').nav_file(1)<CR>"}
map {noremap = false, 'n', '<A-w>', ":lua require('harpoon.ui').nav_file(2)<CR>"}
map {noremap = false, 'n', '<A-e>', ":lua require('harpoon.ui').nav_file(3)<CR>"}
map {noremap = false, 'n', '<A-r>', ":lua require('harpoon.ui').nav_file(4)<CR>"}

-- Nvim lint
map {noremap = false, 'n', '<leader>cl', ":lua require('lint').try_lint()<CR>"}

-- Fugitive
map {noremap = false, 'n', '<leader>gs', ':Git<CR>'}

