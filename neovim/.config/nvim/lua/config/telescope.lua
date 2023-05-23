local telescope = require("telescope")

telescope.setup({
    defaults = {
        file_ignore_patterns = { "vendor" },
        mappings = {
            i = {
                ["<esc>"] = require("telescope.actions").close
            }
        }
    }
})

telescope.load_extension("fzf")
telescope.load_extension("luasnip")

-- local builtin = require("telescope.builtin")
-- local luasnip = telescope.extensions.luasnip

-- nmap("<leader>b", builtin.git_branches)
-- nmap("<leader>f", builtin.find_files)
-- nmap("<leader>s", luasnip.luasnip)
-- nmap("<leader>/", builtin.live_grep)
-- xmap("<leader>/", builtin.grep_string)
-- nmap("<leader><space>", builtin.buffers)
