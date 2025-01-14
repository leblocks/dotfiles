local function terminal_config()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
end

local function get_launch_terminal_command()
    local current_directory = vim.fn.expand('%:p:h')
    current_directory = '\\"' .. current_directory:gsub(" ", "\\ ") .. '\\"'

    local command = "pwsh -NoLogo -NoProfileLoadTime"

    if (not current_directory:find("term://")) then
        command = command .. " -WorkingDirectory " .. current_directory
    end

    return command
end

vim.api.nvim_create_autocmd({ 'TermOpen' },
    {
        pattern = '*',
        callback = terminal_config,
        group = vim.api.nvim_create_augroup('terminal_config', { clear = true })
    })

vim.api.nvim_create_user_command('Terminal', function()
    vim.cmd(":e term://" .. get_launch_terminal_command())
end, {})

vim.api.nvim_create_user_command('TTerminal', function()
    vim.cmd(":tabnew term://" .. get_launch_terminal_command())
end, {})

vim.api.nvim_create_user_command('VTerminal', function()
    vim.cmd(":vnew term://" .. get_launch_terminal_command())
end, {})

vim.api.nvim_create_user_command('STerminal', function()
    vim.cmd(":split term://" .. get_launch_terminal_command())
end, {})

