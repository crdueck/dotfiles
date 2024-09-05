require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true,
        disable = { "netrw" },
    },
    indent = {
        enable = false
    },
    ensure_installed = {
        "bash",
        "dockerfile",
        "go",
        "hcl",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "php",
        "python",
        "rego",
        "vimdoc",
        "yaml",
    },
})
