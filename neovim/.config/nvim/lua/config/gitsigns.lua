local gitsigns = require("gitsigns")

gitsigns.setup({
    signcolumn = false,
    numhl = true,
    on_attach = function(bufnr)
        local function map(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
        end

        map("n", "]c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "]c", bang = true })
            else
                gitsigns.next_hunk()
            end
        end)

        map("n", "[c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "[c", bang = true })
            else
                gitsigns.prev_hunk()
            end
        end)

        map('n', '<leader>hs', gitsigns.stage_hunk)
        map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        map('n', '<leader>hS', gitsigns.stage_buffer)
        map("n", "<leader>hr", gitsigns.reset_hunk)
        map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        map('n', '<leader>hR', gitsigns.reset_buffer)
        map('n', '<leader>hu', gitsigns.undo_stage_hunk)
        map("n", "<leader>hp", gitsigns.preview_hunk)
        map("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end)

        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
    end
})
