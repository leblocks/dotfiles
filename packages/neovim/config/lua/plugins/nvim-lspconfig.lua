-- lsp config
local os = require('os')

local bash_server_location = os.getenv('NEOVIM_BASH_LANGUAGE_SERVER') or '~'
local lua_server_location = os.getenv('NEOVIM_LUA_LANGUAGE_SERVER') or '~'
local roslyn_server_location = os.getenv('NEOVIM_ROSLYN_LANGUAGE_SERVER') or '~'
local powershell_server_location = os.getenv('NEOVIM_POWERSHELL_LANGUAGE_SERVER') or '~'
local pyright_server_location = os.getenv('NEOVIM_PYRIGHT_LANGUAGE_SERVER') or '~'
local typescript_server_location = os.getenv('NEOVIM_TYPESCRIPT_LANGUAGE_SERVER') or '~'
local vscode_html_server_location = os.getenv('NEOVIM_VSCODE_HTML_LANGUAGE_SERVER') or '~'

vim.lsp.config('pyright', {
    autostart = false,
    cmd = { pyright_server_location, '--stdio' },
})

vim.lsp.config('ts_ls', {
    autostart = false,
    cmd = { typescript_server_location, '--stdio' },
})

vim.lsp.config('bashls', {
    autostart = false,
    cmd = { bash_server_location, 'start' },
})

-- lua server configuration, with specifics for neovim
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                -- get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file('', true),
            },
            -- do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
    autostart = false,
    cmd = { lua_server_location },
})

vim.lsp.config('powershell_es', {
    autostart = false,
    bundle_path = powershell_server_location,
})

vim.lsp.config('html', {
    autostart = false,
    cmd = { vscode_html_server_location, '--stdio' },
})

vim.lsp.config('roslyn_ls', {
    autostart = false,
    cmd = {
        'dotnet',
        roslyn_server_location,
        '--logLevel',
        'Information',
        '--extensionLogDirectory',
        vim.fs.joinpath(vim.uv.os_tmpdir(), 'roslyn_ls/logs'),
        '--stdio',
    },
})
