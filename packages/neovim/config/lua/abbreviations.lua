local csharp_autocmd_group = vim.api.nvim_create_augroup('csharp_abbreviations', { clear = true })
local function csharp_abbreviations()
    vim.cmd('iabbrev <buffer> psvm public static void Main(string[] args)<CR>{<CR>}<esc>O')
    vim.cmd('iabbrev <buffer> cwl System.Console.WriteLine($"");<esc>3h')
    vim.cmd('iabbrev <buffer> tryb try<CR>{<CR>}<CR>catch (Exception ex)<CR>{<CR>throw;<CR>}<esc>4kO')
end

vim.api.nvim_create_autocmd({ 'FileType' },
    { pattern = 'cs', callback = csharp_abbreviations, group = csharp_autocmd_group })

-- general abbreviations
vim.cmd('iabbrev td TODO')
vim.cmd("iab ts <ESC>:lua vim.api.nvim_put({ require('os').date('%d%m%Y') .. ' ' }, 'b', true, true)<CR>i")

