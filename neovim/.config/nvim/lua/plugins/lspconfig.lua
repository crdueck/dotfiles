return {
    "neovim/nvim-lspconfig",
    config = function()
        local function on_attach(client, bufnr)
            local function nmap(lhs, rhs)
                vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true })
            end

            nmap("ga", vim.lsp.buf.code_action)
            nmap("gd", vim.lsp.buf.definition)
            nmap("gD", vim.lsp.buf.type_definition)
            nmap("gi", vim.lsp.buf.implementation)
            nmap("gl", vim.lsp.buf.incoming_calls)
            nmap("gL", vim.lsp.buf.outgoing_calls)
            nmap("gr", vim.lsp.buf.references)
            nmap("gs", vim.lsp.buf.rename)

            nmap("<c-n>", vim.diagnostic.goto_next)
            nmap("<c-p>", vim.diagnostic.goto_prev)
            nmap("<leader>d", vim.diagnostic.setqflist)

            if client.supports_method("documentFormattingProvider") then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function() vim.lsp.buf.format() end,
                })
            end
        end

        local function lspconfig(lsp, opts)
            local options = {
                on_attach = on_attach,
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            }

            if opts then
                options = vim.tbl_extend("force", options, opts)
            end

            require("lspconfig")[lsp].setup(options)
        end

        lspconfig("gopls")
        lspconfig("jsonls", { cmd = { "vscode-json-languageserver", "--stdio" } })
        -- lspconfig("yamlls")

        -- lspconfig("hls", {
        --     cmd = { "haskell-language-server-wrapper", "--lsp" },
        --     filetypes = { "haskell", "lhaskell", "cabal" },
        -- })

        lspconfig("lua_ls", {
            cmd = { "/usr/bin/lua-language-server" },
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" }
                    },
                    telemetry = {
                        enable = false
                    },
                }
            }
        })
    end
}
