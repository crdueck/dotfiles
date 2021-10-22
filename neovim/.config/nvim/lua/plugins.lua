require("packer").startup(function(use)
    use "wbthomason/packer.nvim"

    use "ggandor/lightspeed.nvim"
    use "hoob3rt/lualine.nvim"
    use "kaicataldo/material.vim"
    use "neovim/nvim-lspconfig"
    use "windwp/nvim-autopairs"

    use {
        "L3MON4D3/LuaSnip",
        requires = {
            "rafamadriz/friendly-snippets"
        }
    }

    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind-nvim",
        }
    }

    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
        }
    }

    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

    use "tpope/vim-commentary"
    use "tpope/vim-fugitive"
    use "tpope/vim-repeat"
    use "tpope/vim-surround"
    use "tpope/vim-vinegar"
end)

-- colorscheme
vim.g.material_theme_style = "darker"
vim.cmd("colorscheme material")

-- autopairs
require("nvim-autopairs").setup({ check_ts = true })
require("nvim-autopairs.completion.cmp").setup({ map_complete = true })

-- cmp
local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")

cmp.setup({
    formatting = {
        format = lspkind.cmp_format()
    },
    mapping = {
        ["<C-c>"] = cmp.mapping.close(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<CR>"] = cmp.mapping.confirm({ select = true}),
        ["<Tab>"] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end,
        ["<S-Tab>"] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
    }
})

-- lightspeed
require("lightspeed").setup({
    labels = { "a", "h", "o", "t", "e", "n", "u", "s", "i", "d",  }
})

-- lspconfig
local function on_attach(client, bufnr)
    local function buf_nmap(lhs, rhs)
        vim.api.nvim_buf_set_keymap(bufnr, "n", lhs, rhs, { noremap = true, silent = true })
    end

    buf_nmap("gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
    buf_nmap("gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
    buf_nmap("gr", "<cmd>lua vim.lsp.buf.references()<cr>")
    buf_nmap("gq", "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>")
    buf_nmap("K", "<cmd>lua vim.lsp.buf.hover()<cr>")

    buf_nmap("[g", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>")
    buf_nmap("]g", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>")

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    if client.resolved_capabilities.document_formatting then
        vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
    end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local function setup_lspconfig(lsp, opts)
    local options = { on_attach = on_attach, capabilities = capabilities }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    require("lspconfig")[lsp].setup(options)
end

setup_lspconfig("clangd")
setup_lspconfig("yamlls")
setup_lspconfig("jsonls", { cmd = { "vscode-json-languageserver", "--stdio" } })
setup_lspconfig("gopls")
setup_lspconfig("hls")
setup_lspconfig("sumneko_lua", {
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

-- lualine
require("lualine").setup({
    options = {
        theme = "material",
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            {
                "branch",
                icon = ""
            }
        },
        lualine_c = { "filename" },
        lualine_x = {
            {
                "diagnostics",
                sources = { "nvim_lsp" },
                symbols = { error = " ", info = " " , warn = " " },
            }
       },
        lualine_y = { "filetype" },
        lualine_z = { "progress" },
    },
    inactive_sections = {
        lualine_c = { "filename" },
        lualine_x = { "progress" },
    },
})

-- luasnip
require("luasnip.loaders.from_vscode").load()

-- telescope
require("telescope").setup({
    defaults = {
        file_ignore_patterns = { "vendor" },
        mappings = {
            i = {
                ["<esc>"] = require("telescope.actions").close
            }
        }
    }
})

require("telescope").load_extension("fzf")

nmap("<leader>f", "<cmd>Telescope find_files<cr>")
nmap("<leader>g", "<cmd>Telescope git_status<cr>")
nmap("<leader>s", "<cmd>Telescope live_grep<cr>")
nmap("<leader><space>", "<cmd>Telescope buffers<cr>")

-- treesitter
require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true
    },
    indent = {
        enable = true
    },
})
