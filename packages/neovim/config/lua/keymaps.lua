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
map('n', '<Leader>fd', ':Telescope fd<CR>', default_opts)
map('n', '<Leader>fF', ':Telescope current_buffer_fuzzy_find<CR>', default_opts)
map('n', '<Leader>fg', ':Telescope live_grep<CR>', default_opts)
map('n', '<Leader>fG', ':Telescope grep_string<CR>', default_opts)

-- (l)ist commands
map('n', '<Leader>lb', ':Telescope buffers<CR>', default_opts)
map('n', '<Leader>lq', ':copen<CR>', default_opts)
map('n', '<Leader>ll', ':lopen<CR>', default_opts)
map('n', '<Leader>lt', ':Telescope treesitter<CR>', default_opts)
map('n', '<Leader>l]', ':Telescope tags<CR>', default_opts)
map('n', '<Leader>ls', ':Telescope lsp_document_symbols<CR>', default_opts)
map('n', '<Leader>lS', ':Telescope lsp_workspace_symbols<CR>', default_opts)
map('n', '<Leader>le', ':Telescope diagnostics bufnr=0<CR>', default_opts)
map('n', '<Leader>lE', ':Telescope diagnostics<CR>', default_opts)
map('n', '<Leader>la', ':lua vim.lsp.buf.code_action()<CR>', default_opts)
map('n', '<Leader>lm', ':Telescope marks<CR>', default_opts)
map('n', '<Leader>lc', ':Telescope commands<CR>', default_opts)
map('n', '<Leader>lC', ':Telescope colorscheme<CR>', default_opts)
map('n', '<Leader>l/', ':Telescope builtin<CR>', default_opts)
map('n', '<Leader>lk', ':Telescope keymaps<CR>', default_opts)

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
register_lsp_keybindings('bashls', 'sh')
register_lsp_keybindings('pyright', 'python')
register_lsp_keybindings('lua_ls', { 'lua' })
register_lsp_keybindings('powershell_es', { 'ps1' })
register_lsp_keybindings('ts_ls', { 'javascript', 'typescript' })
register_lsp_keybindings('html', { 'html' })

-- some utility mappings
map('n', '<Leader>3', ':NoNeckPain<CR>', default_opts)
map('n', '<Leader>5', ':TSToggle highlight<CR> :e<CR>', default_opts)

-- terminal
map('n', '<Leader>0v', ':vnew term://pwsh -NoLogo<CR>', default_opts)
map('n', '<Leader>0t', ':tabnew term://pwsh -NoLogo<CR>', default_opts)
map('n', '<Leader>0x', ':split term://pwsh -NoLogo<CR>', default_opts)
map('n', '<Leader>00', ':terminal pwsh -NoLogo<CR>', default_opts)
map('t', '<Esc>', [[<C-\><C-n>]], default_opts)

-- (b)uffer
map('n', '<Leader>bd', ':bdelete!<CR>', default_opts)

