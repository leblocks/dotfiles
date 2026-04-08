require('nvim-treesitter').install({
    'bash',
    'c_sharp',
    'dockerfile',
    'html',
    'javascript',
    'json',
    'lua',
    'powershell',
    'python',
    'sql',
    'typescript',
    'yaml',
    'markdown',
    'xml',
})

-- set code folding
vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo[0][0].foldmethod = 'expr'

-- indentation
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

-- highlights (TODO, add here more while encounterint new filetypes)
vim.api.nvim_create_autocmd('FileType', { pattern = { 'cs', }, callback = function() vim.treesitter.start() end, })
vim.api.nvim_create_autocmd('FileType', { pattern = { 'xml', }, callback = function() vim.treesitter.start() end, })
vim.api.nvim_create_autocmd('FileType', { pattern = { 'ps1', }, callback = function() vim.treesitter.start() end, })
vim.api.nvim_create_autocmd('FileType', { pattern = { 'markdown', }, callback = function() vim.treesitter.start() end, })
