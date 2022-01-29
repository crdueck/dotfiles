local fn = vim.fn
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

require("packer").startup(function(use)
    use "wbthomason/packer.nvim"

    use {
        "ggandor/lightspeed.nvim",
        config = function()
            require("config.lightspeed")
        end
    }

    use {
        "catppuccin/nvim",
        as = "catppuccin",
        config = function()
            require("config.catppuccin")
        end
    }

    use {
        "neovim/nvim-lspconfig",
        config = function()
            require("config.lspconfig")
        end
    }

    use {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("config.lualine")
        end
    }

    use {
        "windwp/nvim-autopairs",
        config = function()
            require("config.autopairs")
        end
    }

    use {
        "L3MON4D3/LuaSnip",
        requires = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end
    }

    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind-nvim"
        },
        config = function()
            require("config.cmp")
        end
    }

    use {
        "nvim-telescope/telescope.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("config.telescope")
        end
    }

    use {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make"
    }

    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require("config.treesitter")
        end
    }

    use "tpope/vim-commentary"
    use "tpope/vim-fugitive"
    use "tpope/vim-repeat"
    use "tpope/vim-surround"
    use "tpope/vim-vinegar"
end)
