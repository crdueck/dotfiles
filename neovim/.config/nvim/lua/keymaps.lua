function _G.cmap(...) vim.keymap.set("c", ...) end
function _G.nmap(...) vim.keymap.set("n", ...) end
function _G.xmap(...) vim.keymap.set("x", ...) end

-- force quit
cmap("qq", "qa!")

-- replace visual selection in file
-- xmap("gs", "y:%s/<c-r>\"//g<left><left>")

-- save thousands of keystrokes
nmap(";", ":")

-- better directional movement
nmap("j", "v:count == 0 ? 'gj' : 'j'", { silent = true, expr = true })
nmap("k", "v:count == 0 ? 'gk' : 'k'", { silent = true, expr = true })

-- avoid clobbering yank register
nmap("x", "\"_x")
nmap("c", "\"_c")

-- execute 'q' macro instead of Ex mode
nmap("Q", "@q")

-- clear search highlighting
nmap("<space>", "<cmd>nohlsearch<cr>", { silent = true })
