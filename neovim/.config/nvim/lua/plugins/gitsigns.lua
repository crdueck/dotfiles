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

            map('n', ']c', function()
                if vim.wo.diff then
                    vim.cmd.normal({ ']c', bang = true })
                else
                    gitsigns.next_hunk()
                end
            end)

            map('n', '[c', function()
                if vim.wo.diff then
                    vim.cmd.normal({ '[c', bang = true })
                else
                    gitsigns.prev_hunk()
                end
            end)

            map("n", "hb", function() gitsigns.blame_line({ full = true }) end)
            map("n", "hk", gitsigns.preview_hunk)
            map("n", "hr", gitsigns.reset_hunk)
            map('n', 'hR', gitsigns.reset_buffer)
            map('n', 'hs', gitsigns.stage_hunk)
            map('n', 'hS', gitsigns.stage_buffer)
            map('n', 'hu', gitsigns.undo_stage_hunk)

            map('v', 'hr', function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)
            map('v', 'hs', function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)

            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end
    }
}
