
local views_autocmd_group = vim.api.nvim_create_augroup('views', { clear = true })

vim.api.nvim_create_autocmd('BufWinLeave', {
    pattern = '*.*',
    callback = function() vim.cmd('mkview') end,
    group = views_autocmd_group
})

vim.api.nvim_create_autocmd('BufWinEnter', {
    pattern = '*.*',
    callback = function() vim.cmd('silent loadview') end,
    group = views_autocmd_group
})

