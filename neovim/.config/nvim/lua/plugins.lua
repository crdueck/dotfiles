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
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require("config.gitsigns")
        end
    },

    {
        "alexghergh/nvim-tmux-navigation",
        config = function()
            require("config.nvim-tmux-navigation")
        end
    },

    {
        "ggandor/leap.nvim",
        config = function()
            require("config.leap")
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
        "nvim-neotest/neotest",
        ft = "go",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neotest/nvim-nio",
            "nvim-neotest/neotest-go",
            "antoinemadec/FixCursorHold.nvim",
        },
        config = function()
            require("config.neotest")
        end
    },

    {
        "shaunsingh/nord.nvim",
        config = function()
            require("config.nord")
        end
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("config.autopairs")
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
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "onsails/lspkind-nvim",
            "saadparwaiz1/cmp_luasnip",
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
        },
        config = function()
            require("config.telescope")
        end
    },

    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
            require("telescope").load_extension("fzf")
        end
    },

    {
          "folke/trouble.nvim",
          opts = {},
          cmd = "Trouble",
          keys = {
            {
              "<leader>xx",
              "<cmd>Trouble diagnostics toggle<cr>",
              desc = "Diagnostics (Trouble)",
            },
            {
              "<leader>xX",
              "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
              desc = "Buffer Diagnostics (Trouble)",
            },
            {
              "<leader>xt",
              "<cmd>Trouble symbols toggle focus=false<cr>",
              desc = "Symbols (Trouble)",
            },
        },
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
    "tpope/vim-rhubarb",
    "tpope/vim-surround",
    "tpope/vim-vinegar",
})
