require("telescope").setup({
    defaults = {
        file_ignore_patterns = { "vendor" },
        mappings = {
            i = {
                ["<esc>"] = require("telescope.actions").close
            }
        }
    }
})

telescope = require("telescope.builtin")

nmap("<leader>b", telescope.git_branches)
nmap("<leader>f", telescope.find_files)
nmap("<leader>g", telescope.git_status)
nmap("<leader>s", telescope.live_grep)
nmap("<leader><space>", telescope.buffers)
