local cmp = require("cmp")
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))


cmp_autopairs.lisp[#cmp_autopairs.lisp+1] = "racket"
cmp.setup{
    completion = {
        keyword_pattern  = "ääääääää",
        keyword_length = 1
    },
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    mapping = {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-x>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Sace>"] = function(fallback)
            if not cmp.select_next_item() then
                if vim.bo.buftype ~= "prompt" and has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end
        end,
        ["<S-Tab>"] = function(fallback)
            if not cmp.select_prev_item() then
                if vim.bo.buftype ~= "prompt" and has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end
        end,
        ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    },
    sources = {
        {name = "nvim_lsp"},
        {name = "ultisnips", max_item_count = 3},
        {name = "buffer", max_item_count = 3},
        {name = "path"},
    },
    formatting = {
        format = function(entry, vim_item)
            -- fancy icons and a name of kind
            vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
            return vim_item
        end
    }
}

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer', max_item_count = 5 }
    }
})

-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--     sources = cmp.config.sources({
--         { name = 'path', max_item_count = 5 }
--     }, {
--         { name = 'cmdline', max_item_count = 5 }
--     })
-- })
