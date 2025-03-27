-- lsp config
local os = require('os')

local pyright_server_location = os.getenv('NEOVIM_PYRIGHT_LANGUAGE_SERVER') or '~'
local typescript_server_location = os.getenv('NEOVIM_TYPESCRIPT_LANGUAGE_SERVER') or '~'
local bash_server_location = os.getenv('NEOVIM_BASH_LANGUAGE_SERVER') or '~'
local lua_server_location = os.getenv('NEOVIM_LUA_LANGUAGE_SERVER') or '~'
local powershell_server_location = os.getenv('NEOVIM_POWERSHELL_LANGUAGE_SERVER') or '~'
local vscode_html_server_location = os.getenv('NEOVIM_VSCODE_HTML_LANGUAGE_SERVER') or '~'

local capabilities = require('cmp_nvim_lsp')
    .default_capabilities(vim.lsp.protocol.make_client_capabilities())

local lsp_config = require('lspconfig')
local lsp_signature = require('lsp_signature')

local on_attach = function(_, bufnr)
    -- specifies what to do when language server attaches to the buffer
    vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })
    lsp_signature.on_attach({
        doc_lines = 15,
        max_height = 15,
        max_width = 100,
        bind = true,
        handler_opts = {
            border = "none"
        },
    }, bufnr)
end

lsp_config.pyright.setup({
    autostart = false,
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
    cmd = { pyright_server_location, "--stdio" },
})

lsp_config.ts_ls.setup({
    autostart = false,
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { typescript_server_location, "--stdio" },
})

lsp_config.bashls.setup({
    autostart = false,
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { bash_server_location, "start" },
})

-- lua server configuration, with specifics for neovim
lsp_config.lua_ls.setup({
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
    capabilities = capabilities,
    cmd = { lua_server_location, },
})

lsp_config.powershell_es.setup({
    autostart = false,
    on_attach = on_attach,
    capabilities = capabilities,
    bundle_path = powershell_server_location,
})

lsp_config.html.setup({
    autostart = false,
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { vscode_html_server_location, "--stdio" },
})

