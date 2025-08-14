require('lualine').setup({
    options = {
        icons_enabled = false,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'encoding', 'fileformat', 'filetype'},
        lualine_c = { { 'filename', path = 1, } },
        lualine_x = {'diagnostics', 'selectioncount', 'lsp_status' },
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
})

