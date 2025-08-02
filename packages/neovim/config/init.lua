-- faster startup time
-- if possible
if vim.loader ~= nil
then
    vim.loader.enable()
end

require('settings')
require('plugins')
require('keymaps')
require('abbreviations')
require('terminal')
require('commands')
require('complete')
require('session')
require('treesitter-diagnostics')
require('global')
require('plugins.lualine')
require('plugins.treesitter')
require('plugins.nvim-lspconfig')
require('plugins.nvim-ts-autotag')
require('plugins.fzf-lua')
require('plugins.hopcsharp')

