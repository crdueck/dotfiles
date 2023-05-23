require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true
    },
    indent = {
        enable = false
    },
    ensure_installed = {
        "bash",
        "c",
        "dockerfile",
        "go",
        "haskell",
        "json",
        "lua",
        "markdown",
        "python",
        "yaml",
    },
})
