local os = require('os')

local cmd = vim.cmd
local opt = vim.opt

-- general stuff
opt.wildmenu = true
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.fileencodings = "utf-8"
opt.showcmd  = true
opt.hlsearch = true
opt.incsearch = true
opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.number = true
opt.relativenumber = true
opt.scrolloff = 10
opt.colorcolumn = '120'
opt.wrap = false
opt.showmode = false
opt.swapfile = false
opt.scl = 'number' -- merge signocolumn with number
opt.clipboard = 'unnamed'
opt.hidden = true
opt.termguicolors = true
opt.cursorline = true
opt.syntax = 'enable'
opt.filetype = 'on'
opt.mouse = ''
opt.exrc = true

-- spellcheck configuration
opt.spelllang = 'en'
opt.spellsuggest = 'best,9'

-- disable python provider support to speed-up start time
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0

-- hide status line
vim.o.showmode = false
vim.o.ruler = false
vim.o.showcmd = false
vim.o.laststatus = 0

cmd [[
    " highlight trailing spaces
    set list
    set listchars=trail:·
    colorscheme catppuccin-mocha
]]

