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
require('plugins.lualine')
require('plugins.luatab')
require('plugins.whip')
require('plugins.no-neck-pain')
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
require('plugins.nvim-ts-autotag')
require('plugins.copilot')
require('plugins.roslyn')
require('plugins.vim-gutentags')
