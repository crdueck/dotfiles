local disabled_builtins = {
    "gzip",
    "matchit",
    "rplugin",
    "shada_plugin",
    "tarPlugin",
    "tutor_mode_plugin",
    "zipPlugin",
    "2html_plugin",
}

for _, builtin in ipairs(disabled_builtins) do
    vim.g["loaded_"..builtin] = true
end

vim.g.mapleader = ","
vim.g.netrw_fastbrowse = 0

require("keymaps")
require("options")
require("plugins")
