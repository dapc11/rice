local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").load()
local cmp = require("cmp")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on( "confirm_done", cmp_autopairs.on_confirm_done({  map_char = { tex = "" } }))


local kind_icons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = ""
}


cmp_autopairs.lisp[#cmp_autopairs.lisp+1] = "racket"
cmp.setup{
    completion = {completeopt = "menu,menuone,noinsert"},
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ["<CR>"] = cmp.mapping({
            i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
            c = function(fallback)
                if cmp.visible() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
                else
                    fallback()
                end
            end
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    },
    sources = {
        {name = "nvim_lsp", max_item_count = 10},
        {name = "buffer", max_item_count = 8, keyword_length = 2},
        {name = "luasnip", max_item_count = 10}, -- For luasnip users.
        {name = "path", max_item_count = 10},
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
        return vim_item
      end,
    },
    documentation = {
        border = {"╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder',
    }
}

-- Use buffer source for `/` (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline("/", {
    sources = {
        { name = "buffer", max_item_count = 10, keyword_length = 5 }
    }
})
cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
        { name = "path", keyword_length = 2 }
    }, {
        { name = "cmdline", keyword_length = 2 }
    })
})
vim.cmd [[
autocmd FileType gitcommit,fugitive lua require("cmp").setup.buffer { sources = { { name = "buffer", max_item_count = 10 }, } }
]]

-- _G.vimrc = _G.vimrc or {}
-- _G.vimrc.cmp = _G.vimrc.cmp or {}
-- _G.vimrc.cmp.on_text_changed = function()
--   local cursor = vim.api.nvim_win_get_cursor(0)
--   local line = vim.api.nvim_get_current_line()
--   local before = string.sub(line, 1, cursor[2] + 1)
--   if before:match('%s*$') then
--     cmp.complete() -- Trigger completion only if the cursor is placed at the end of line.
--   end
-- end
-- vim.cmd([[
--   augroup cmp
--     autocmd
--     autocmd TextChanged,TextChangedI,TextChangedP * call luaeval('vimrc.cmp.on_text_changed()')
--   augroup END
-- ]])
