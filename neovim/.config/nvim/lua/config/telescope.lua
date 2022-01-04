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

nmap("<leader>b", "<cmd>Telescope git_branches<cr>")
nmap("<leader>f", "<cmd>Telescope find_files<cr>")
nmap("<leader>g", "<cmd>Telescope git_status<cr>")
nmap("<leader>s", "<cmd>Telescope live_grep<cr>")
nmap("<leader><space>", "<cmd>Telescope buffers<cr>")
