-- faster startup time
-- if possible
if vim.loader ~= nil then
    vim.loader.enable()
end

require('global')
require('settings')
require('plugins')
require('keymaps')
require('bookmark')
require('abbreviations')
require('terminal')
require('commands')
require('complete')
require('quickfix')
require('treesitter-diagnostics')
require('plugins.lualine')
require('plugins.treesitter')
require('plugins.nvim-lspconfig')
require('plugins.nvim-ts-autotag')
require('plugins.fzf-lua')
require('plugins.hopcsharp')
require('plugins.toggle')
