local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")

cmp.event:on('confirm_done', require("nvim-autopairs.completion.cmp").on_confirm_done())

cmp.setup({
    completion = {
        keyword_length = 2,
    },
    formatting = {
        format = lspkind.cmp_format({
            with_text = false,
            menu = {
                buffer = "buf",
                luasnip = "snip",
                nvim_lsp = "lsp",
                nvim_lua = "vim",
            }
        })
    },
    mapping = {
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-c>"] = cmp.mapping.close(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-n>"] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end,
        ["<C-p>"] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end,
        ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" })
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    sources = {
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "buffer" },
    },
})
