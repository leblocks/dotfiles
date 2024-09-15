local os = require('os')

require('whip').setup({
    dir = (os.getenv('OneDrive') or os.getenv('USERPROFILE') or os.getenv('HOME')) .. '/whip'
})
