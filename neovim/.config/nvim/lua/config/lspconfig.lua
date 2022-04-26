local function on_attach(client, bufnr)
    local function buf_nmap(lhs, rhs)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true })
    end

    buf_nmap("K", vim.lsp.buf.hover)

    buf_nmap("ga", vim.lsp.buf.code_action)
    buf_nmap("gD", vim.lsp.buf.declaration)
    buf_nmap("gd", vim.lsp.buf.definition)
    buf_nmap("gi", vim.lsp.buf.implementation)
    buf_nmap("gr", vim.lsp.buf.references)
    buf_nmap("gs", vim.lsp.buf.rename)

    buf_nmap("<leader>d", vim.lsp.diagnostic.set_loclist)
    buf_nmap("[d", vim.lsp.diagnostic.goto_prev)
    buf_nmap("]d", vim.lsp.diagnostic.goto_next)

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    if client.resolved_capabilities.document_formatting then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = vim.lsp.buf.formatting_sync,
        })
    end

    -- disable diagnostics in helm files until treesitter grammar supports embedded go templates
    if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
        vim.diagnostic.disable(bufnr)
        vim.defer_fn(function()
            vim.diagnostic.reset(nil, bufnr)
        end, 1000)
    end
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local function lspconfig_setup(lsp, opts)
    local options = { on_attach = on_attach, capabilities = capabilities }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    require("lspconfig")[lsp].setup(options)
end

lspconfig_setup("gopls")
lspconfig_setup("jsonls")
lspconfig_setup("terraformls")
lspconfig_setup("yamlls")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = false,
        update_in_insert = true,
    }
)
