local gitsigns = require("gitsigns")
gitsigns.setup({
    signcolumn = false,
    numhl = true,

    on_attach = function(bufnr)
        local function map(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
        end

        map("n", "<leader>hs", gitsigns.stage_hunk)
        map("n", "<leader>hS", gitsigns.stage_buffer)
        map("n", "<leader>hr", gitsigns.reset_hunk)
        map("n", "<leader>hR", gitsigns.reset_buffer)
        map("n", "<leader>hu", gitsigns.undo_stage_hunk)
        map("n", "<leader>hp", gitsigns.preview_hunk)

        map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>")
    end
})
