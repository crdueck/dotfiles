return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "saadparwaiz1/cmp_luasnip",
        "onsails/lspkind-nvim",
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())

        cmp.setup({
            preselect = cmp.PreselectMode.None,
            completion = {
                keyword_length = 2,
            },
            formatting = {
                format = require("lspkind").cmp_format({
                    mode = "symbol",
                    menu = {
                        nvim_lsp = "lsp",
                        nvim_lua = "vim",
                        luasnip = "snip",
                    }
                })
            },
            mapping = {
                ["<C-c>"] = cmp.mapping.close(),
                ["<C-b>"] = cmp.mapping.scroll_docs(-5),
                ["<C-f>"] = cmp.mapping.scroll_docs(5),
                ["<CR>"] = cmp.mapping.confirm({
                    select = true,
                    behavior = cmp.ConfirmBehavior.Insert,
                }),
                ["<C-n>"] = cmp.mapping.select_next_item({
                    behavior = cmp.ConfirmBehavior.Insert,
                }),
                ["<C-p>"] = cmp.mapping.select_prev_item({
                    behavior = cmp.ConfirmBehavior.Insert,
                }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },
            sources = {
                { name = "luasnip" },
                { name = "nvim_lua" },
                { name = "nvim_lsp" },
            }
        })
    end
}
