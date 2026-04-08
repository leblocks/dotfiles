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
require('plugins.lualine')
require('plugins.nvim-lspconfig')
require('plugins.fzf-lua')
require('plugins.toggle')
