local os = require('os')

local whip_path = (os.getenv('OneDrive') or os.getenv('USERPROFILE') or os.getenv('HOME')) .. '/whip'
print(whip_path)

if vim.fn.isdirectory(whip_path) ~= 0 then
    require('whip').setup({
        dir = whip_path
    })
end

