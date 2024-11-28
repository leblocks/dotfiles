local action_layout = require('telescope.actions.layout')

local telescope = require('telescope')

telescope.setup({
    defaults = {
        mappings = {
            n = {
                ["<M-p>"] = action_layout.toggle_preview
            },
            i = {
                ["<M-p>"] = action_layout.toggle_preview
            }
        },

        preview = {
            hide_on_startup = true
        },

        layout_strategy = 'horizontal',
        layout_config = { height = 0.95, width = 0.95, preview_width = 0.5 },
    },

    extensions = {
        fzy_native = {
            override_generic_sorter = true,
            override_file_sorter = true,
        }
    }
})

telescope.load_extension('fzy_native')
telescope.load_extension('ui-select')

