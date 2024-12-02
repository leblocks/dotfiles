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
require('terminal')
require('commands')
require('plugins.lualine')
require('plugins.luatab')
require('plugins.whip')
require('plugins.no-neck-pain')
require('plugins.nvim-cmp')
require('plugins.filetype')
require('plugins.telescope')
require('plugins.nvim-tree')
require('plugins.treesitter')
require('plugins.nvim-lspconfig')
require('plugins.nvim-ts-autotag')
require('plugins.roslyn')
require('plugins.vim-gutentags')
