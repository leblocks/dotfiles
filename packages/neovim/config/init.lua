-- faster startup time
-- if possible
if vim.loader ~= nil then
    vim.loader.enable()
end

-- load plugins first
require('plugins')
require('global')
require('settings')
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
require('plugins.nvim-treesitter')
require('plugins.hopcsharp')
