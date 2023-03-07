vim.g.mapleader = ","
vim.g.netrw_fastbrowse = 0

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

require("autocmds")
require("options")
require("keymaps")
require("plugins")

-- TODO features
-- fugitive status toggle
-- open all telescope selections / send to qf
-- automatically accept code actions (go imports)
-- telescope ui for selections: https://github.com/nvim-telescope/telescope-ui-select.nvim
