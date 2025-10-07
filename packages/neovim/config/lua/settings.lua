local os = require('os')

local opt = vim.opt

-- general stuff
opt.wildmenu = true
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'
opt.fileencodings = 'utf-8'
opt.showcmd = true
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

-- trailing whitespaces
vim.o.list = true
vim.o.listchars = 'trail:·'

-- sqlite support for windows
if vim.loop.os_uname().sysname == 'Windows_NT' then
    vim.g.sqlite_clib_path = os.getenv('NEOVIM_SQLITE_DLL_PATH') or '~'
end

vim.api.nvim_command('colorscheme space_vim_theme')

if vim.fn.executable('pwsh') == 1 then
    vim.o.shell = 'pwsh'
    vim.api.nvim_command(
        [[ let &shellcmdflag = '-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';$PSStyle.OutputRendering=''plaintext'';Remove-Alias -Force -ErrorAction SilentlyContinue tee;' ]]
    )
    vim.o.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
    vim.o.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
    vim.o.shellquote = ''
    vim.o.shellxquote = ''
end
