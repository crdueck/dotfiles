return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
        require("nvim-treesitter.configs").setup({
            highlight = {
                enable = true
            },
            indent = {
                enable = false
            },
            textobjects = {
                select = {
                    enable = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                    }
                }
            },
            ensure_installed = {
                "bash",
                "c",
                "dockerfile",
                "go",
                "hcl",
                "html",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "php",
                "python",
                "regex",
                "rego",
                "vimdoc",
                "yaml",
            },
        })
    end
}
