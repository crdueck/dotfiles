local opt = vim.opt

-- General
opt.clipboard = opt.clipboard + "unnamedplus"
opt.completeopt = "menuone,noselect"
opt.mouse = "a"
opt.number = true
opt.scrolljump = 5
opt.scrolloff = 5
opt.shortmess = opt.shortmess + "c"
opt.showmode = false
opt.splitright = true
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
opt.list = true
opt.listchars = { tab = "▷•", trail = "•" }
opt.shiftwidth = 4
opt.tabstop = 4