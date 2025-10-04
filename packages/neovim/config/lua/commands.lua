vim.api.nvim_create_user_command("ToggleStatusLine", function()
    vim.o.showmode = not vim.o.showmode
    vim.o.ruler = not vim.o.ruler
    vim.o.showcmd = not vim.o.showcmd
    vim.o.laststatus = vim.o.laststatus == 2 and 0 or 2
end, {})

vim.api.nvim_create_user_command("BufRemoveTrailingSpaces", function()
    vim.cmd([[:%s/\s\+$//e]])
end, {})

vim.api.nvim_create_user_command("BufSetUnixFileFormat", function()
    vim.cmd([[:set fileformat=unix]])
end, {})

vim.api.nvim_create_user_command("BufCopyPath", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify("copied to clipboard " .. path)
end, {})

vim.api.nvim_create_user_command("HopcsharpInitDatabase", require("hopcsharp").init_database, {})
