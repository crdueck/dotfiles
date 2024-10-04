return {
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
        { "<leader>g",       "<cmd>Telescope git_status<cr>" },
        { "<leader>s",       "<cmd>Telescope luasnip<cr>" },
        { "<leader>/",       "<cmd>Telescope live_grep<cr>" },
        { "<leader>/",       "<cmd>Telescope grep_string<cr>", mode = "x" },
        { "<leader><space>", "<cmd>Telescope buffers<cr>" },
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.load_extension("fzf")
        telescope.load_extension("luasnip")

        telescope.setup({
            defaults = {
                file_ignore_patterns = { "vendor" },
                mappings = {
                    i = {
                        ["<esc>"] = actions.close,
                    },
                }
            },
        })
    end
}
