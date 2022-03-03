local function on_attach(client, bufnr)
    local function buf_nmap(lhs, rhs)
        vim.api.nvim_buf_set_keymap(bufnr, "n", lhs, rhs, { noremap = true, silent = true })
    end

    buf_nmap("K", "<cmd>lua vim.lsp.buf.hover()<cr>")

    buf_nmap("ga", "<cmd>lua vim.lsp.buf.code_action()<cr>")
    buf_nmap("gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
    buf_nmap("gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
    buf_nmap("gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
    buf_nmap("gr", "<cmd>lua vim.lsp.buf.references()<cr>")
    buf_nmap("gs",  "<cmd>lua vim.lsp.buf.rename()<cr>")

    buf_nmap("<leader>d", "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>")
    buf_nmap("[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>")
    buf_nmap("]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>")

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    if client.resolved_capabilities.document_formatting then
        vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
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
