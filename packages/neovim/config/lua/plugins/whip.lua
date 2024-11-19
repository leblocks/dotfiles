local os = require('os')

local whip_path = (os.getenv('OneDrive') or os.getenv('USERPROFILE') or os.getenv('HOME')) .. '/whip'

if vim.fn.isdirectory(whip_path) ~= 0 then
    require('whip').setup({
        dir = whip_path
    })
else
    print('could not find "' .. whip_path .. '" disabling whip')
end

