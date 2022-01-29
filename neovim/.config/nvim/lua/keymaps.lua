local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function _G.cmap(...) map("c", ...) end
function _G.nmap(...) map("n", ...) end
function _G.xmap(...) map("x", ...) end

-- force quit
cmap("qq", "qa!")

-- save thousands of keystrokes
nmap(";", ":")

-- simpler window movement
nmap("<c-h>", "<c-w>h")
nmap("<c-j>", "<c-w>j")
nmap("<c-k>", "<c-w>k")
nmap("<c-l>", "<c-w>l")

-- smarter line movement
nmap("j", "v:count == 0 ? 'gj' : 'j'", { silent = true, expr = true })
nmap("k", "v:count == 0 ? 'gk' : 'k'", { silent = true, expr = true })

-- avoid clobbering yank register
nmap("x", "\"_x")
nmap("c", "\"_c")

-- execute 'q' macro instead of Ex mode
nmap("Q", "@q")

-- clear search highlighting
nmap("<space>", "<cmd>nohlsearch<cr>", { silent = true })
