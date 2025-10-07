require('nvim-treesitter.configs').setup({
    ensure_installed = {
        'bash',
        'c_sharp',
        'dockerfile',
        'html',
        'javascript',
        'json',
        'lua',
        'powershell',
        'python',
        'sql',
        'typescript',
        'yaml',
        'markdown',
        'xml',
    },

    additional_vim_regex_highlighting = false,

    highlight = {
        enable = true,
    },

    indent = {
        enable = true,
    },

    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<Leader>v',
            node_incremental = '<Leader>v',
            scope_incremental = false,
            node_decremental = '<Leader>V',
        },
    },
})

-- had to do it on windows machine
-- use clang to compile language grammar
if vim.loop.os_uname().sysname == 'Windows_NT' then
    require('nvim-treesitter.install').compilers = { 'clang', 'gcc' }
end

-- set code folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = false
