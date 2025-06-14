-- lsp config
local os = require('os')

local pyright_server_location = os.getenv('NEOVIM_PYRIGHT_LANGUAGE_SERVER') or '~'
local typescript_server_location = os.getenv('NEOVIM_TYPESCRIPT_LANGUAGE_SERVER') or '~'
local bash_server_location = os.getenv('NEOVIM_BASH_LANGUAGE_SERVER') or '~'
local lua_server_location = os.getenv('NEOVIM_LUA_LANGUAGE_SERVER') or '~'
local powershell_server_location = os.getenv('NEOVIM_POWERSHELL_LANGUAGE_SERVER') or '~'
local vscode_html_server_location = os.getenv('NEOVIM_VSCODE_HTML_LANGUAGE_SERVER') or '~'
local omnisharp_server_location = os.getenv('OMNISHARP_LANGUAGE_SERVER') or '~'

local pid = vim.fn.getpid()

-- TODO see if this is needed
local on_attach = function(_, bufnr)
    -- specifies what to do when language server attaches to the buffer
    -- vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })
end

vim.lsp.config('pyright', {
    autostart = false,
    on_attach = on_attach,
    cmd = { pyright_server_location, "--stdio" },
})

vim.lsp.config('ts_ls', {
    autostart = false,
    on_attach = on_attach,
    cmd = { typescript_server_location, "--stdio" },
})

vim.lsp.config('bashls', {
    autostart = false,
    on_attach = on_attach,
    cmd = { bash_server_location, "start" },
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
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
    autostart = false,
    on_attach = on_attach,
    cmd = { lua_server_location, },
})

vim.lsp.config('powershell_es', {
    autostart = false,
    on_attach = on_attach,
    bundle_path = powershell_server_location,
})

vim.lsp.config('html', {
    autostart = false,
    on_attach = on_attach,
    cmd = { vscode_html_server_location, "--stdio" },
})

vim.lsp.config('omnisharp', {
    autostart = false,
    on_attach = on_attach,
    cmd = {
        omnisharp_server_location,
        "-z",
        "--hostPID", tostring(pid),
        "DotNet:enablePackageRestore=false",
        "--encoding", "utf-8",
        "--languageserver",
    },
})
