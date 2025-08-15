local os = require('os')


local fn = vim.fn
-- packer installation bootstrapping
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({
        'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
        install_path
    })
end

local packer = require('packer')

return packer.startup(function(use)
    use('ibhagwan/fzf-lua')

    -- treesitter
    use('nvim-treesitter/nvim-treesitter')
    use('windwp/nvim-ts-autotag')

    -- hail to the tpope
    use('tpope/vim-surround')
    use('tpope/vim-fugitive')
    use('tpope/vim-commentary')
    use('tpope/vim-vinegar')
    use('tpope/vim-unimpaired')

    -- lsp
    use('neovim/nvim-lspconfig')

    -- ui
    use({ 'nvim-lualine/lualine.nvim' })

    -- hopcsharp yay
    -- use({ 'leblocks/hopcsharp.nvim', requires = { { 'kkharji/sqlite.lua' } } })
    use({ '../hopcsharp.nvim', requires = { { 'kkharji/sqlite.lua' } } })

    if packer_bootstrap then
        packer.sync()
    end
end)
