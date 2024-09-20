local function cmap(...) vim.keymap.set("c", ...) end
local function nmap(...) vim.keymap.set("n", ...) end
local function xmap(...) vim.keymap.set("x", ...) end

-- disable right mouse
vim.keymap.set({ "c", "n", "x", "i", "s" }, "<RightMouse>", "<nop>")

-- force quit
cmap("qq", "qa!")

-- save thousands of keystrokes
nmap(";", ":")

-- simpler window movement
nmap("<c-h>", "<c-w>h")
nmap("<c-j>", "<c-w>j")
nmap("<c-k>", "<c-w>k")
nmap("<c-l>", "<c-w>l")

-- search/replace visual selection in file
xmap("gs", "y:%s/<c-r>\"//gI<left><left><left>")
-- nmap("gs", "*ye:%s/<c-r>\"//gI<left><left><left>")

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

-- buffer movement
nmap("<right>", "<cmd>bn<cr>", { silent = true })
nmap("<left>", "<cmd>bp<cr>", { silent = true })
