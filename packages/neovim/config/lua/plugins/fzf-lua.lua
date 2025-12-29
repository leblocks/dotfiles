require('fzf-lua').setup({
    defaults = {
        file_icons = false,
        silent = true,
    },

    winopts = {
        fullscreen = true,
        preview = {
            hidden = true,
        },
    },

    fzf_opts = {
        ['--layout'] = 'default',
    },
})
