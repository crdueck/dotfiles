require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true
    },
    indent = {
        enable = false
    },
    auto_install = true,
    ensure_installed = {
        "bash",
        "c",
        "dockerfile",
        "go",
        "haskell",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "vimdoc",
        "yaml",
    },
})
