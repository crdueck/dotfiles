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
            nmap("gr", vim.lsp.buf.references)
            nmap("gs", vim.lsp.buf.rename)
            nmap("gt", vim.lsp.buf.incoming_calls)
            nmap("gT", vim.lsp.buf.outgoing_calls)

            nmap("<c-n>", vim.diagnostic.goto_next)
            nmap("<c-p>", vim.diagnostic.goto_prev)
            nmap("<leader>d", vim.diagnostic.setqflist)

            if client.supports_method("documentFormattingProvider") then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function() vim.lsp.buf.format() end,
                })
            end

            local buf_ft = vim.bo[bufnr].filetype

            -- disable autoformat for PHP/Rego
            if buf_ft ~= "rego" and buf_ft ~= "php" then
                if client.server_capabilities["documentFormattingProvider"] then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function() vim.lsp.buf.format({ async = true }) end,
                    })
                end
            end

            -- disable diagnostics for Helm until treesitter supports embedded Go templates
            if vim.bo[bufnr].buftype ~= "" or buf_ft == "helm" then
                vim.diagnostic.disable(bufnr)
                vim.defer_fn(function() vim.diagnostic.reset(nil, bufnr) end, 1000)
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

        lspconfig("gopls", {
            settings = {
                gopls = {
                    buildFlags = { "-tags=integration" }
                }
            }
        })

        -- lspconfig("phpactor", {
        --     init_options = {
        --         ["indexer.include_patterns"] = {"/**/*.php","/**/*.phps"},
        --     },
        -- })

        -- lspconfig("jsonls", { cmd = { "vscode-json-languageserver", "--stdio" } })
        lspconfig("jsonls")
        lspconfig("yamlls")
        lspconfig("terraformls")

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

        local configs = require("lspconfig.configs")

        if not configs.golangcilsp then
            configs.golangcilsp = {
                default_config = {
                    cmd = { "golangci-lint-langserver" },
                    filetypes = { "go", "gomod" },
                    root_dir = require("lspconfig").util.root_pattern(".git", "go.mod"),
                    init_options = {
                        command = { "golangci-lint", "run", "--out-format", "json", "--issues-exit-code=1" },
                    }
                },
            }
        end

        lspconfig("golangcilsp")
    end
}
