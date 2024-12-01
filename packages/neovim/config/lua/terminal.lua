local function terminal_config()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
end

vim.api.nvim_create_autocmd({ 'TermOpen' },
    {
        pattern = '*',
        callback = terminal_config,
        group = vim.api.nvim_create_augroup('terminal_config', { clear = true })
    })

