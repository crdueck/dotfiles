local function on_attach(client, bufnr)
    local function buf_nmap(lhs, rhs)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true })
    end

    buf_nmap("K", vim.lsp.buf.hover)
    buf_nmap("ga", vim.lsp.buf.code_action)
    buf_nmap("gd", vim.lsp.buf.definition)
    buf_nmap("gD", vim.lsp.buf.type_definition)
    buf_nmap("gi", vim.lsp.buf.implementation)
    buf_nmap("gr", vim.lsp.buf.references)
    buf_nmap("gs", vim.lsp.buf.rename)

    buf_nmap("<leader>e", vim.diagnostic.open_float)
    buf_nmap("<leader>dq", vim.diagnostic.setloclist)
    buf_nmap("<c-n>", vim.diagnostic.goto_next)
    buf_nmap("<c-p>", vim.diagnostic.goto_prev)

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    if client.server_capabilities["documentFormattingProvider"] then
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
lspconfig("hls")
lspconfig("jsonls", { cmd = { "vscode-json-languageserver", "--stdio" } })
lspconfig("yamlls")
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
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            }
        }
    }
})
