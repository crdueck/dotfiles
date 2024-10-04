local disabled_builtins = {
    "2html_plugin",
    "fzf",
    "gzip",
    "matchit",
    "remote_plugins",
    "shada_plugin",
    "spellfile_plugin",
    "tarPlugin",
    "tutor_mode_plugin",
    "zipPlugin",
}

for _, builtin in ipairs(disabled_builtins) do
    vim.g["loaded_" .. builtin] = 1
end
