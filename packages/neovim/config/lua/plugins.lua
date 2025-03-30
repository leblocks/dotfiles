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
    use('seblj/roslyn.nvim')

    use('nathom/filetype.nvim')

    -- ui
    use({ 'nvim-lualine/lualine.nvim' })
    use({ 'alvarosevilla95/luatab.nvim' })

    -- note taking
    use('slugbyte/whip.nvim')

    -- center buffer
    use({"shortcuts/no-neck-pain.nvim", tag = "*" })

    -- keep track of configuration performance
    use('dstein64/vim-startuptime')

    -- marks
    use('chentoast/marks.nvim')

    -- colorschemes
    use({ "catppuccin/nvim", as = "catppuccin" })
    use({ 'sainnhe/everforest' })
    use({ 'rebelot/kanagawa.nvim' })
    use({ 'jackplus-xyz/binary.nvim' })

    if packer_bootstrap then
        packer.sync()
    end
end)
