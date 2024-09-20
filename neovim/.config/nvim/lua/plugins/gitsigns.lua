return {
    "lewis6991/gitsigns.nvim",
    opts = {
        numhl = true,
        signcolumn = false,
        on_attach = function(bufnr)
            local function map(mode, lhs, rhs)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
            end

            local gitsigns = require("gitsigns")

            map("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end)
            map("n", "<leader>hk", gitsigns.preview_hunk)
            map("n", "<leader>hn", gitsigns.next_hunk)
            map("n", "<leader>hp", gitsigns.prev_hunk)
            map("n", "<leader>hr", gitsigns.reset_hunk)
            map('n', '<leader>hR', gitsigns.reset_buffer)
            map('n', '<leader>hS', gitsigns.stage_buffer)
            map('n', '<leader>hs', gitsigns.stage_hunk)
            map('n', '<leader>hu', gitsigns.undo_stage_hunk)

            map('v', '<leader>hr', function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)
            map('v', '<leader>hs', function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)

            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end
    }
}
