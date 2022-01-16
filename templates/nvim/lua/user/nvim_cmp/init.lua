local cmp = require("cmp")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on( "confirm_done", cmp_autopairs.on_confirm_done({  map_char = { tex = "" } }))


cmp_autopairs.lisp[#cmp_autopairs.lisp+1] = "racket"
cmp.setup{
    completion = {completeopt = 'menu,menuone,noinsert'},
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    mapping = {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping({
            i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
            c = function(fallback)
                if cmp.visible() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
                else
                    fallback()
                end
            end
        }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    },
    sources = {
        {name = "nvim_lsp", max_item_count = 10},
        {name = "buffer", max_item_count = 5, keyword_length = 5},
        {name = "ultisnips", max_item_count = 3},
        {name = "path", max_item_count = 8},
    },
    formatting = {
        format = function(entry, vim_item)
            -- fancy icons and a name of kind
            vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
            return vim_item
        end
    }
}


-- Use buffer source for `/` (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline("/", {
    sources = {
        { name = "buffer", max_item_count = 10, keyword_length = 5 }
    }
})
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path', max_item_count = 5, keyword_length = 2 }
    }, {
        { name = 'cmdline', max_item_count = 15, keyword_length = 2 }
    })
})
vim.cmd [[
autocmd FileType gitcommit,fugitive lua require('cmp').setup.buffer { sources = { { name = "buffer", max_item_count = 5 }, } }
]]
