return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
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
            "regex",
            "markdown",
            "markdown_inline",
            "python",
            "vimdoc",
            "yaml",
        },
    }
}
