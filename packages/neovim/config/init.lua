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
require('complete')
require('session')
require('plugins.lualine')
require('plugins.whip')
require('plugins.no-neck-pain')
require('plugins.filetype')
require('plugins.telescope')
require('plugins.treesitter')
require('plugins.nvim-lspconfig')
require('plugins.nvim-ts-autotag')
require('plugins.roslyn')

