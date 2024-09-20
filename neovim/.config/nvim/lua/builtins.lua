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
