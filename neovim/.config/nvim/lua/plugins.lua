local fn = vim.fn
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

require("packer").startup(function(use)
    use "wbthomason/packer.nvim"

    use {
        "alexghergh/nvim-tmux-navigation",
        config = function()
            require("config.nvim-tmux-navigation")
        end
    }

    use {
        "ggandor/lightspeed.nvim",
        config = function()
            require("config.lightspeed")
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
        "shaunsingh/nord.nvim",
        config = function()
            require("config.nord")
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
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "onsails/lspkind-nvim",
            "saadparwaiz1/cmp_luasnip",
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
        run = "make",
        config = function()
            require("telescope").load_extension("fzf")
        end
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
