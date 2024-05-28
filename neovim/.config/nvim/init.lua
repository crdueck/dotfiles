local disabled_builtins = {
    "2html_plugin",
    "fzf",
    "gzip",
    "matchit",
    "matchparen",
    "rplugin",
    "shada_plugin",
    "tarPlugin",
    "tutor_mode_plugin",
    "vimball",
    "vimballPlugin",
    "zipPlugin",
}

for _, builtin in ipairs(disabled_builtins) do
    vim.g["loaded_" .. builtin] = 1
end

-- vim.opt.runtimepath:remove("/etc/xdg/nvim")
-- vim.opt.runtimepath:remove("/etc/xdg/nvim/after")
-- vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")

vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.netrw_fastbrowse = 0

require("autocmds")
require("keymaps")
require("options")
require("plugins")

-- TODO
-- toggle fugitive status keymap
-- lsp-aware search/replace in file/project
-- map("<leader>tt", neotest.summary.toggle)
-- nmap("<leader>to", neotest.output.open)
