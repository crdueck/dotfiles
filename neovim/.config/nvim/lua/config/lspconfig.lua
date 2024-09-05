lspconfig = require("lspconfig")

local function on_attach(client, bufnr)
    local function buf_nmap(lhs, rhs)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true })
    end

    buf_nmap("K", vim.lsp.buf.hover)

    buf_nmap("ga", vim.lsp.buf.code_action)
    buf_nmap("gd", vim.lsp.buf.definition)
    buf_nmap("gt", vim.lsp.buf.type_definition)
    buf_nmap("gi", vim.lsp.buf.implementation)
    buf_nmap("gr", vim.lsp.buf.references)
    buf_nmap("gs", vim.lsp.buf.rename)

    buf_nmap("gD", vim.diagnostic.open_float)
    buf_nmap("<leader>d", vim.diagnostic.setqflist)
    buf_nmap("<c-n>", vim.diagnostic.goto_next)
    buf_nmap("<c-p>", vim.diagnostic.goto_prev)

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    local buf_ft = vim.bo[bufnr].filetype

    -- disable autoformat for PHP/Rego until others agree to standardize style
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

local function lspconfig_setup(lsp, opts)
    local options = {
        on_attach    = on_attach,
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
    }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    lspconfig[lsp].setup(options)
end

lspconfig_setup("gopls", {
    settings = {
        gopls = {
            buildFlags = {"-tags=integration"}
        }
    }
})

lspconfig_setup("jsonls")

-- https://phpactor.readthedocs.io/en/master/reference/configuration.html
lspconfig_setup("phpactor", {
    init_options = {
        ["indexer.include_patterns"] = {"/**/*.php","/**/*.phps"},
    },
})

lspconfig_setup("terraformls")
lspconfig_setup("yamlls")

local configs = require("lspconfig.configs")

if not configs.regols then
    configs.regols = {
        default_config = {
          cmd = {"regols"},
          filetypes = {"rego"},
          root_dir = lspconfig.util.root_pattern(".git"),
        }
    }
end

lspconfig_setup("regols")

if not configs.golangcilsp then
    configs.golangcilsp = {
        default_config = {
            cmd = {"golangci-lint-langserver"},
            filetypes = {"go", "gomod"},
            root_dir = lspconfig.util.root_pattern(".git", "go.mod"),
            init_options = {
                command = { "golangci-lint", "run", "--out-format", "json", "--issues-exit-code=1" },
            }
        };
    }
end

lspconfig_setup("golangcilsp")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = false,
        update_in_insert = true,
    }
)
