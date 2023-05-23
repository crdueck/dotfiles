require("lualine").setup({
    options = {
        globalstatus = true,
        theme = "palenight",
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            {
                "branch",
                icon = ""
            }
        },
        lualine_c = { "filename" },
        lualine_x = {
            {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                symbols = { error = " ", info = " ", warn = " " },
            }
        },
        lualine_y = { "filetype" },
        lualine_z = { "progress" },
    },
    inactive_sections = {
        lualine_c = { "filename" },
        lualine_x = { "progress" },
    },
})
