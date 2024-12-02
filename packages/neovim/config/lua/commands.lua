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

vim.api.nvim_create_user_command('RemoveTrailingWhiteSpaces',function()
    vim.cmd([[:%s/\s\+$//e]])
end, {})

vim.api.nvim_create_user_command('RenameBuffer',function()
    vim.ui.input({ prompt = "new buffer name: " }, function(input) vim.cmd(":silent keepalt noautocmd file " .. input) end)
end, {})

vim.api.nvim_create_user_command('SetUnixFileFormat',function()
    vim.cmd([[:set fileformat=unix]])
end, {})

