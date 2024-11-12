require('utils')

local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true, silent = true}

map('i', 'jj', '<Esc>', {noremap = true})

-- make Y work as expected (same as C and D)
map('n', 'Y', 'y$', {noremap = true})

-- center screen after n and N during search and during J, <C-d> and <C-u>
map('n', 'n', 'nzzzv', {noremap = true})
map('n', 'N', 'Nzzzv', {noremap = true})
map('n', 'J', 'mzJ`z', {noremap = true})
map('n', '<C-d>', '<C-d>zzzv', {noremap = true})
map('n', '<C-u>', '<C-u>zzzv', {noremap = true})

-- set undo breakpoints to make undo command more comfortable to use
map('i', ',', ',<c-g>u', {noremap = true})
map('i', '.', '.<c-g>u', {noremap = true})
map('i', '!', '!<c-g>u', {noremap = true})
map('i', '?', '?<c-g>u', {noremap = true})

vim.g.mapleader = ' '

map('n', '<Leader>w', ':w<CR>', default_opts)
map('n', '<Leader>W', ':w!<CR>', default_opts)
map('n', '<Leader>q', ':q<CR>', default_opts)
map('n', '<Leader>Q', ':q!<CR>', default_opts)
map('n', '<Leader><Leader>', ':nohl<CR>', default_opts)

-- localist and quickfix list navigation
map('n', '<C-n>', ':cnext<CR>', default_opts)
map('n', '<C-p>', ':cprev<CR>', default_opts)
map('n', '<C-k>', ':lprev<CR>', default_opts)
map('n', '<C-j>', ':lnext<CR>', default_opts)

-- (f)ind commnands
map('n', '<Leader>ff', ':Telescope find_files find_command=fd<CR>', default_opts)
map('n', '<Leader>fF', ':Telescope current_buffer_fuzzy_find<CR>', default_opts)
map('n', '<Leader>fg', ':Telescope live_grep<CR>', default_opts)
map('n', '<Leader>fG', ':Telescope grep_string<CR>', default_opts)

-- (l)ist commands
map('n', '<Leader>lb', ':Telescope buffers<CR>', default_opts)
map('n', '<Leader>lq', ':copen<CR>', default_opts)
map('n', '<Leader>ll', ':lopen<CR>', default_opts)
map('n', '<Leader>lt', ':Telescope treesitter<CR>', default_opts)
map('n', '<Leader>ls', ':Telescope lsp_document_symbols<CR>', default_opts)
map('n', '<Leader>lS', ':Telescope lsp_workspace_symbols<CR>', default_opts)
map('n', '<Leader>le', ':Telescope diagnostics bufnr=0<CR>', default_opts)
map('n', '<Leader>lE', ':Telescope diagnostics<CR>', default_opts)
map('n', '<Leader>la', ':lua vim.lsp.buf.code_action()<CR>', default_opts)
map('n', '<Leader>lm', ':Telescope marks<CR>', default_opts)
map('n', '<Leader>lc', ':lua CommonActions()<CR>', default_opts)

-- (g)oto commands
map('n', 'gr', ':Telescope lsp_references<CR>', default_opts)
map('n', 'gd', ':Telescope lsp_definitions<CR>', default_opts)
map('n', 'gi', ':Telescope lsp_implementations<CR>', default_opts)

-- code (a)ctions
map('n', '<Leader>ah', ':lua vim.lsp.buf.hover()<CR>', default_opts)
map('n', '<Leader>ar', ':lua vim.lsp.buf.rename()<CR>', default_opts)
map('n', '<Leader>af', ':lua vim.lsp.buf.format({ async = True })<CR>', default_opts)
-- TODO make it work!
map('v', '<Leader>af', ':lua vim.lsp.buf.format({ async = True })<CR>', default_opts)

-- language (s)erver specific bindings for language server commands
local function register_lsp_keybindings(ls_server_name, pattern)
    local group = vim.api.nvim_create_augroup(ls_server_name .. "_augroup", { clear = true })
    local event = { "FileType" }

    local function server_start_callback()
        vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>ss', ':LspStart ' .. ls_server_name .. '<CR>', default_opts)
    end

    local function server_attach_callback()
        vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>sa', ':lua AttachCurrentBufferToLspClientByName(\'' .. ls_server_name .. '\')<CR>', default_opts)
    end

    vim.api.nvim_create_autocmd(event, { pattern = pattern, callback = server_start_callback , group = group })
    vim.api.nvim_create_autocmd(event, { pattern = pattern, callback = server_attach_callback , group = group })
end

map('n', '<Leader>si', ':LspInfo<CR>', default_opts)
register_lsp_keybindings('omnisharp', 'cs')
register_lsp_keybindings('csharp_ls', 'cs')
register_lsp_keybindings('bashls', 'sh')
register_lsp_keybindings('pyright', 'python')
register_lsp_keybindings('lua_ls', { 'lua' })
register_lsp_keybindings('powershell_es', { 'ps1' })
register_lsp_keybindings('ts_ls', { 'javascript', 'typescript' })
register_lsp_keybindings('html', { 'html' })

-- some utility mappings
map('n', '<Leader>1', ':NvimTreeToggle<CR>', default_opts)
map('n', '<Leader>!', ':NvimTreeFindFileToggle<CR>', default_opts)
map('n', '<Leader>2', ':lua require("lint").try_lint()<CR>', default_opts)
map('n', '<Leader>3', ':NoNeckPain<CR>', default_opts)
map('n', '<Leader>4', ':CopilotChatToggle<CR>', default_opts)
map('n', '<Leader>5', ':TSToggle highlight<CR> :e<CR>', default_opts)

-- debugger mappings
map('n', '<F4>', ":lua require('dap').run_last()<CR>", default_opts)
map('n', '<F5>', ":lua require('dap').continue()<CR>", default_opts)
map('n', '<F6>', ":lua require('dap').disconnect()<CR>", default_opts)
map('n', '<F7>', ":lua require('dap').terminate()<CR>", default_opts)
map('n', '<F10>', ":lua require('dap').step_over()<CR>", default_opts)
map('n', '<F11>', ":lua require('dap').step_into()<CR>", default_opts)
map('n', '<F12>', ":lua require('dap').step_out()<CR>", default_opts)

-- debugger (t)oggles
map('n', '<Leader>tb', ":lua require('dap').toggle_breakpoint()<CR>", default_opts)
map('n', '<Leader>tbc', ":lua require('dap').toggle_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", default_opts)
map('n', '<Leader>tbl', ":lua require('dap').toggle_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", default_opts)
map('n', '<Leader>tu', ":lua require('dapui').toggle()<CR>", default_opts)

-- whip bindings
map('n', '<Leader>no', ':WhipOpen<CR>', default_opts)
map('n', '<Leader>nm', ':WhipMake<CR>', default_opts)
map('n', '<Leader>nd', ':WhipDrop<CR>', default_opts)
map('n', '<Leader>nf', ':WhipFindFile<CR>', default_opts)
map('n', '<Leader>ng', ':WhipFindGrep<CR>', default_opts)

-- copilot bindings
map('i', '<M-a>', 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })

