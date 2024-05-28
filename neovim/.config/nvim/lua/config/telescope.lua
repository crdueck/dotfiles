local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.load_extension("fzf")
telescope.load_extension("luasnip")

telescope.setup({
    defaults = {
        file_ignore_patterns = { "vendor" },
        -- prompt_prefix = "  ",
        mappings = {
            i = {
                ["<esc>"] = actions.close,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist
            },
        }
    },
})
