vim.api.nvim_create_user_command('ToggleBackGroundColor',function()
    local background = vim.opt.background._value
    if background == "dark" then
        vim.opt.background = "light"
    else
        vim.opt.background = "dark"
    end
end, {})

vim.api.nvim_create_user_command('ToggleStatusLine',function()
    vim.o.showmode = not vim.o.showmode
    vim.o.ruler = not vim.o.ruler
    vim.o.showcmd = not vim.o.showcmd
    vim.o.laststatus = vim.o.laststatus == 2 and 0 or 2
end, {})

vim.api.nvim_create_user_command('ToggleSpellCheck',function()
    vim.cmd([[:set spell!]])
end, {})

vim.api.nvim_create_user_command('BufRemoveTrailingSpaces',function()
    vim.cmd([[:%s/\s\+$//e]])
end, {})

vim.api.nvim_create_user_command('BufRename',function(opts)
    vim.cmd(":silent keepalt noautocmd file " .. opts.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command('BufSetUnixFileFormat',function()
    vim.cmd([[:set fileformat=unix]])
end, {})

vim.api.nvim_create_user_command('BufCopyPath', function()
    local path = vim.fn.expand('%:p')
    vim.fn.setreg('+', path)
    vim.notify('copied to clipboard ' .. path)
end, {})

vim.api.nvim_create_user_command('BufFileExplorer', function()
    local path = vim.fn.expand('%:p:h')
    vim.cmd(':terminal pwsh -NoLogo -Command mc . ' .. path .. ' --nocolor')
end, {})

