local fn = vim.fn
-- packer installation bootstrapping
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
        install_path })
end

local packer = require('packer')

return packer.startup(function(use)
    use({ 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/plenary.nvim' } } })
    use('nvim-telescope/telescope-fzy-native.nvim')
    use('nvim-telescope/telescope-ui-select.nvim')

    use('nvim-treesitter/nvim-treesitter')

    use('nvim-tree/nvim-tree.lua')

    use('tpope/vim-surround')
    use('tpope/vim-fugitive')
    use('tpope/vim-commentary')

    use('neovim/nvim-lspconfig')
    use('ray-x/lsp_signature.nvim')
    use('ray-x/cmp-treesitter')

    use('hrsh7th/nvim-cmp')
    use('hrsh7th/cmp-buffer')
    use('hrsh7th/cmp-nvim-lsp')

    use('morhetz/gruvbox')
    use('Mofiqul/vscode.nvim')
    use('ntk148v/komau.vim')

    use('kyazdani42/nvim-web-devicons')
    use('nathom/filetype.nvim')

    use({ 'nvim-lualine/lualine.nvim', requires = { 'nvim-tree/nvim-web-devicons', opt = true } })

    -- nvim-dap
    use('mfussenegger/nvim-dap')
    use('theHamsta/nvim-dap-virtual-text')
    use('rcarriga/nvim-dap-ui')

    -- nvim-lint for cases when there is no lsp server
    use('mfussenegger/nvim-lint')
    -- keep track of configuration performance
    use('dstein64/vim-startuptime')

    if packer_bootstrap then
        packer.sync()
    end
end)
