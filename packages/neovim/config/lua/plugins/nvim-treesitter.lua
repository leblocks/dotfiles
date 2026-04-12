require('nvim-treesitter').install({
    'bash',
    'c_sharp',
    'html',
    'lua',
    'markdown',
    'powershell',
    'xml',
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'cs' },
    callback = function()
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'
        vim.treesitter.start(0, 'c_sharp')
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'markdown' },
    callback = function()
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'
        vim.treesitter.start(0, 'markdown')
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'ps1' },
    callback = function()
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'
        vim.treesitter.start(0, 'powershell')
    end,
})

