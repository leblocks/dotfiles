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

function OpenTerminal(vertical)
    -- name of the buffer can be changed by keepalt file new_name
    vim.ui.input({ prompt = 'Provide terminal name' }, function(input)
        local command = (vertical == true and 'vnew' or 'split') .. ' term://pwsh -NoLogo'
        vim.cmd [[ command ]]
    end)
end

