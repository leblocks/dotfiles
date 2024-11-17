-- lsp config
local os = require('os')

local pyright_server_location = os.getenv('PYRIGHT_LANGUAGE_SERVER') or '~'
local typescript_server_location = os.getenv('TYPESCRIPT_LANGUAGE_SERVER') or '~'
local angular_server_location = os.getenv('ANGULAR_LANGUAGE_SERVER') or '~'
local bash_server_location = os.getenv('BASH_LANGUAGE_SERVER') or '~'
local lua_server_location = os.getenv('LUA_LANGUAGE_SERVER') or '~'
local powershell_server_location = os.getenv('POWERSHELL_LANGUAGE_SERVER') or '~'
local vscode_html_server_location = os.getenv('VSCODE_HTML_LANGUAGE_SERVER') or '~'

local capabilities = require('cmp_nvim_lsp')
    .default_capabilities(vim.lsp.protocol.make_client_capabilities())

local pid = vim.fn.getpid()
local lsp_config = require('lspconfig')
local lsp_signature = require('lsp_signature')

local border = {
      {"╭", "FloatBorder"},
      {"─", "FloatBorder"},
      {"╮", "FloatBorder"},
      {"│", "FloatBorder"},
      {"╯", "FloatBorder"},
      {"─", "FloatBorder"},
      {"╰", "FloatBorder"},
      {"│", "FloatBorder"},
}

-- LSP settings (for overriding per client)
local handlers =  {
  ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border}),
  ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border }),
}

local on_attach = function(client, bufnr)
    -- specifies what to do when language server attaches to the buffer
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    lsp_signature.on_attach({
        doc_lines = 15,
        max_height = 15,
        max_width = 100,
        bind = true,
        handler_opts = {
            border = "none"
        }
        ,
    }, bufnr)
end

lsp_config.pyright.setup({
    autostart = false,
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
    cmd = { pyright_server_location, "--stdio" },
})


lsp_config.bashls.setup({
    autostart = false,
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
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
    handlers = handlers,
    cmd = { lua_server_location, },
})

lsp_config.powershell_es.setup({
    autostart = false,
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
    bundle_path = powershell_server_location,
})

lsp_config.html.setup({
    autostart = false,
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
    cmd = { vscode_html_server_location, "--stdio" },
})

local function setup_angularls()
    lsp_config.angularls.setup({
        autostart = false,
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = handlers,
        cmd = {
            angular_server_location,
            "--stdio",
            "--tsProbeLocations", vim.fs.joinpath(angular_server_location, "..", "..", "typescript", "lib"),
            "--ngProbleLocations", vim.fs.joinpath(angular_server_location, "bin"),
            "--clientProcessId=" .. pid,
        }
    })
end

local function setup_tsls()
    lsp_config.ts_ls.setup({
        autostart = false,
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = handlers,
        cmd = { typescript_server_location, "--stdio" },
    })
end

function SelectLanguageServerSetup()
    vim.ui.select({"typescript", "angular"}, { prompt = "Select language server" },
        function(server_name)
            if server_name == "typescript" then
                    setup_tsls()
            elseif server_name == "angular" then
                    setup_angularls()
            end
        end)
end

vim.api.nvim_set_keymap('n', '<Leader>sS', ':lua SelectLanguageServerSetup()<CR>', { noremap = true, silent = true })

