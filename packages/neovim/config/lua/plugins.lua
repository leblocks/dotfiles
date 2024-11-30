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

    use('nvim-tree/nvim-tree.lua')

    -- hail to the tpope
    use('tpope/vim-surround')
    use('tpope/vim-fugitive')
    use('tpope/vim-commentary')

    -- lsp
    use('neovim/nvim-lspconfig')
    use('ray-x/lsp_signature.nvim')
    use('ray-x/cmp-treesitter')
    use('seblj/roslyn.nvim')

    -- completion
    use('hrsh7th/nvim-cmp')
    use('hrsh7th/cmp-nvim-lsp')

    -- ctags
    use('ludovicchabant/vim-gutentags')
    use('quangnguyen30192/cmp-nvim-tags')

    -- colors
    use('morhetz/gruvbox')
    use('Mofiqul/vscode.nvim')
    use('ntk148v/komau.vim')
    use('tyrannicaltoucan/vim-deep-space')

    use('kyazdani42/nvim-web-devicons')
    use('nathom/filetype.nvim')

    -- ui
    use({ 'nvim-lualine/lualine.nvim', requires = { 'nvim-tree/nvim-web-devicons', opt = true } })
    use({ 'alvarosevilla95/luatab.nvim', requires = 'nvim-tree/nvim-web-devicons' })

    -- note taking
    use('slugbyte/whip.nvim')

    -- center buffer
    use({"shortcuts/no-neck-pain.nvim", tag = "*" })

    -- nvim-dap
    use('mfussenegger/nvim-dap')
    use('theHamsta/nvim-dap-virtual-text')
    use({'rcarriga/nvim-dap-ui', requires = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio'} })

    -- keep track of configuration performance
    use('dstein64/vim-startuptime')

    -- copilot integration
    use('github/copilot.vim')
    use({ 'CopilotC-Nvim/CopilotChat.nvim', requires = { 'nvim-lua/plenary.nvim', 'github/copilot.vim' } })

    if packer_bootstrap then
        packer.sync()
    end
end)
