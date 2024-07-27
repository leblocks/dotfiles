-- this configuration of neovim requires following programs on PATH
-- fd (file finder), rg (ripgrep), clang (the one that comes with llvm - for windows machine)
--
-- paths to language servers should be set as env variables:
-- OMNISHARP_LANGUAGE_SERVER
-- PYTHON_LANGUAGE_SERVER
-- TYPESCRIPT_LANGUAGE_SERVER
-- BASH_LANGUAGE_SERVER
-- LUA_LANGUAGE_SERVER
--
-- paths to debuggers:
-- DEBUGPY_PATH
-- NETCOREDBG_PATH
--

-- faster startup time
-- if possible
if vim.loader ~= nil
then
    vim.loader.enable()
end

require('plugins')
require('keymaps')
require('settings')
require('abbreviations')
require('plugins.lualine')
require('plugins.nvim-cmp')
require('plugins.nvim-dap')
require('plugins.filetype')
require('plugins.nvim-lint')
require('plugins.telescope')
require('plugins.nvim-tree')
require('plugins.treesitter')
require('plugins.nvim-dap-ui')
require('plugins.nvim-lspconfig')
require('plugins.nvim-dap-virtual-text')

