require("neotest").setup({
    adapters = {
        require("neotest-go"),
    }
})

neotest = require("neotest")

-- run all tests in current file
nmap("<leader>t", function() neotest.run.run(vim.fn.expand("%")) end)

-- run nearest test case
nmap("<leader>tf", neotest.run.run)
