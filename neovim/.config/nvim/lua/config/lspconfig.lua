local function on_attach(client, bufnr)
    local function buf_nmap(lhs, rhs)
        vim.api.nvim_buf_set_keymap(bufnr, "n", lhs, rhs, { noremap = true, silent = true })
    end

    buf_nmap("K", "<cmd>lua vim.lsp.buf.hover()<cr>")
    -- buf_nmap("<c-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>")

    buf_nmap("ga", "<cmd>lua vim.lsp.buf.code_action()<cr>")
    buf_nmap("gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
    buf_nmap("gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
    buf_nmap("gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
    buf_nmap("gr", "<cmd>lua vim.lsp.buf.references()<cr>")
    buf_nmap("gs", "<cmd>lua vim.lsp.buf.rename()<cr>")

    buf_nmap("<leader>d", "<cmd>lua vim.diagnostic.setloclist()<cr>")
    buf_nmap("]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")
    buf_nmap("[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    if client.resolved_capabilities.document_formatting then
        vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
    end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local function lspconfig(lsp, opts)
    local options = { on_attach = on_attach, capabilities = capabilities }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    require("lspconfig")[lsp].setup(options)
end

lspconfig("gopls")
lspconfig("hls")
lspconfig("jsonls", { cmd = { "vscode-json-languageserver", "--stdio" } })
lspconfig("yamlls")
lspconfig("sumneko_lua", {
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
