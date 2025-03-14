local action_layout = require('telescope.actions.layout')

local telescope = require('telescope')
local builtin = require('telescope.builtin')

local cpu_count = 0
for _ in pairs(vim.loop.cpu_info()) do
    cpu_count = cpu_count + 1
end

telescope.setup({
    defaults = {

        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--trim',
            '--no-binary',
            '--threads=' .. tonumber(cpu_count),
        },

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

    pickers = {
        find_files = {
            find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix' },
        },
    },

    extensions = {
        fzy_native = {
            override_generic_sorter = true,
            override_file_sorter = true,
        }
    }
})


vim.api.nvim_create_user_command('TelescopeFindFilesOfSameExtension', function()
    builtin.find_files({
        find_command = {
            'fd',
            '--type', 'f',
            '--strip-cwd-prefix',
            '--extension', vim.fn.expand('%:e'),
        },
    })
end, {})

vim.api.nvim_create_user_command('TelescopeLiveGrepOfSameType', function()
    builtin.live_grep({
        glob_pattern = "*." .. vim.fn.expand('%:e')
    })
end, {})

vim.api.nvim_create_user_command('TelescopeGrepStringOfSameType', function()
    builtin.grep_string({
        additional_args = {
            "--glob=*." .. vim.fn.expand('%:e')
        },
    })
end, {})

telescope.load_extension('fzy_native')
telescope.load_extension('ui-select')

