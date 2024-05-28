local opt = vim.opt

-- UI
opt.number = true
opt.scrolljump = 5
opt.scrolloff = 5
opt.shortmess = opt.shortmess + "c"
opt.showmode = false
opt.splitright = true
opt.signcolumn = "no"

-- General
opt.clipboard = "unnamedplus"
opt.hidden = true
opt.mouse = "a"
opt.swapfile = false

-- Formatting
opt.formatoptions = "crqj"
opt.linebreak = true
opt.showbreak = "↲"
opt.textwidth = 80
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Whitespace
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.list = true
opt.listchars = { tab = "▷•", trail = "•" }
