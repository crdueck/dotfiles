require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true
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
        "php",
        "python",
        "yaml",
    },
})
