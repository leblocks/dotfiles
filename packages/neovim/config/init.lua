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
require('treesitter-diagnostics')
require('plugins.lualine')
require('plugins.filetype')
require('plugins.treesitter')
require('plugins.nvim-lspconfig')
require('plugins.nvim-ts-autotag')
require('plugins.roslyn')
require('plugins.fzf-lua')
require('plugins.vim-gutentags')

