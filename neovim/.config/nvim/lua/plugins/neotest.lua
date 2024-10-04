return {
    "nvim-neotest/neotest",

    ft = "go",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-neotest/nvim-nio",
        "nvim-neotest/neotest-go",
        "antoinemadec/FixCursorHold.nvim",
    },

    -- opts = {
    --     adapters = {
    --         require("neotest-go")
    --     }
    -- },
    --
    config = function()
        local neotest = require("neotest")

        neotest.setup({
            adapters = {
                require("neotest-go")
            }
        })

        local function nmap(lhs, rhs)
            vim.keymap.set("n", lhs, rhs, { silent = true })
        end

        -- run all tests in file
        nmap("<leader>t", function() neotest.run.run(vim.fn.expand("%")) end)

        -- run nearest test case
        nmap("<leader>tf", neotest.run.run)

        nmap("<leader>tt", neotest.output.toggle)
        nmap("<leader>T", neotest.summary.toggle)
    end
}
