local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("config.gitsigns")
        end
    },

    {
        "ggandor/leap.nvim",
        config = function()
            require("leap").add_default_mappings()
        end
    },

    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            require("catppuccin").load()
        end
    },

    {
        "neovim/nvim-lspconfig",
        config = function()
            require("config.lspconfig")
        end
    },

    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("config.lualine")
        end
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup()
        end
    },

    {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end
    },

    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind-nvim",
        },
        config = function()
            require("config.cmp")
        end
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "benfowler/telescope-luasnip.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        },
        cmd = "Telescope",
        keys = {
            { "<leader>b",       "<cmd>Telescope git_branches<cr>" },
            { "<leader>f",       "<cmd>Telescope find_files<cr>" },
            { "<leader>s",       "<cmd>Telescope luasnip<cr>" },
            { "<leader>/",       "<cmd>Telescope live_grep<cr>" },
            { "<leader>/",       "<cmd>Telescope grep_string<cr>", mode = "x" },
            { "<leader><space>", "<cmd>Telescope buffers<cr>" },
        },
        config = function()
            require("config.telescope")
        end
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("config.treesitter")
        end
    },

    "tpope/vim-commentary",
    "tpope/vim-fugitive",
    "tpope/vim-repeat",
    "tpope/vim-surround",
    "tpope/vim-vinegar",
})
