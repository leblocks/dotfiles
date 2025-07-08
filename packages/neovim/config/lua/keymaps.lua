
local map = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }

map('i', 'jj', '<Esc>', { noremap = true })

-- make Y work as expected (same as C and D)
map('n', 'Y', 'y$', { noremap = true })

-- center screen after n and N during search and during J, <C-d> and <C-u>
map('n', 'n', 'nzzzv', { noremap = true })
map('n', 'N', 'Nzzzv', { noremap = true })
map('n', 'J', 'mzJ`z', { noremap = true })
map('n', '<C-d>', '<C-d>zzzv', { noremap = true })
map('n', '<C-u>', '<C-u>zzzv', { noremap = true })

-- set undo breakpoints to make undo command more comfortable to use
map('i', ',', ',<c-g>u', { noremap = true })
map('i', '.', '.<c-g>u', { noremap = true })
map('i', '!', '!<c-g>u', { noremap = true })
map('i', '?', '?<c-g>u', { noremap = true })

vim.g.mapleader = ' '

map('n', '<Leader>w', ':w<CR>', default_opts)
map('n', '<Leader>W', ':w!<CR>', default_opts)
map('n', '<Leader>q', ':q<CR>', default_opts)
map('n', '<Leader>Q', ':q!<CR>', default_opts)
map('n', '<Leader><Leader>', ':nohl<CR>', default_opts)

-- (f)ile commnands
map('n', '<Leader>ff', ':FzfLua files<CR>', default_opts)
map('n', '<Leader>fb', ':FzfLua blines<CR>', default_opts)

-- (g)rep commands
map('n', '<Leader>gg', ':FzfLua grep<CR>', default_opts)
map('n', '<Leader>gb', ':FzfLua grep_curbuf<CR>', default_opts)
map('n', '<Leader>gw', ':FzfLua grep_cword<CR>', default_opts)
map('n', '<Leader>gW', ':FzfLua grep_cWORD<CR>', default_opts)
map('n', '<Leader>gl', ':FzfLua live_grep<CR>', default_opts)

-- (])ags commands
map('n', '<Leader>]]', ':FzfLua tags<CR>', default_opts)
map('n', '<Leader>]b', ':FzfLua btags<CR>', default_opts)

-- (t)reesitter commands
map('n', '<Leader>tt', ':FzfLua treesitter<CR>', default_opts)

-- (l)ist commands
map('n', '<Leader>l/', ':FzfLua builtin<CR>', default_opts)
map('n', '<Leader>lb', ':FzfLua buffers<CR>', default_opts)
map('n', '<Leader>lq', ':copen<CR>', default_opts)
map('n', '<Leader>ll', ':lopen<CR>', default_opts)
map('n', '<Leader>le', ':FzfLua diagnostics_document<CR>', default_opts)
map('n', '<Leader>lE', ':FzfLua diagnostics_workspace<CR>', default_opts)
map('n', '<Leader>ls', ':FzfLua lsp_document_symbols<CR>', default_opts)
map('n', '<Leader>lS', ':FzfLua lsp_workspace_symbols<CR>', default_opts)
map('n', '<Leader>la', ':FzfLua lsp_code_actions<CR>', default_opts)

-- (g)oto commands
map('n', 'gr', ':FzfLua lsp_references<CR>', default_opts)
map('n', 'gd', ':FzfLua lsp_definitions<CR>', default_opts)
map('n', 'gi', ':FzfLua lsp_implementations<CR>', default_opts)

-- code (a)ctions
local border = {
    { "╭", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╮", "FloatBorder" },
    { "│", "FloatBorder" },
    { "╯", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╰", "FloatBorder" },
    { "│", "FloatBorder" },
}

vim.keymap.set({ 'n' }, '<Leader>as', function() vim.lsp.buf.signature_help({ border = border }) end, { remap = false })
vim.keymap.set({ 'n' }, '<Leader>ah', function() vim.lsp.buf.hover({ border = border }) end, { remap = false })
vim.keymap.set({ 'n' }, '<Leader>at', vim.lsp.buf.typehierarchy, { remap = false })
vim.keymap.set({ 'n' }, '<Leader>ar', vim.lsp.buf.rename, { remap = false })
vim.keymap.set({ 'n', 'v' }, '<Leader>af', vim.lsp.buf.format, { remap = false })

-- language (s)erver specific bindings for language server commands
local function register_lsp_keybindings(ls_server_name, pattern)
    local group = vim.api.nvim_create_augroup(ls_server_name .. "_augroup", { clear = true })
    local event = { "FileType" }

    local function server_start_callback()
        vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>ss', ':LspStart ' .. ls_server_name .. '<CR>', default_opts)
    end

    local function server_attach_callback()
        vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>sa',
            ':lua require("utils").attach_cur_buf_to_lsp_by_name(\'' .. ls_server_name .. '\')<CR>', default_opts)
    end

    vim.api.nvim_create_autocmd(event, { pattern = pattern, callback = server_start_callback, group = group })
    vim.api.nvim_create_autocmd(event, { pattern = pattern, callback = server_attach_callback, group = group })
end

map('n', '<Leader>si', ':LspInfo<CR>', default_opts)
register_lsp_keybindings('bashls', 'sh')
register_lsp_keybindings('pyright', 'python')
register_lsp_keybindings('lua_ls', { 'lua' })
register_lsp_keybindings('powershell_es', { 'ps1' })
register_lsp_keybindings('ts_ls', { 'javascript', 'typescript' })
register_lsp_keybindings('html', { 'html' })
register_lsp_keybindings('omnisharp', { 'cs' })

-- terminal
map('n', '<Leader>00', ':Terminal<CR>', default_opts)
map('n', '<Leader>0v', ':VTerminal<CR>', default_opts)
map('n', '<Leader>0x', ':STerminal<CR>', default_opts)
map('n', '<Leader>0t', ':TTerminal<CR>', default_opts)
map('n', '<Leader>l0', ':SelectTerminal<CR>', default_opts)
map('n', '<Leader>0D', ':CloseTerminals<CR>', default_opts)
map('t', '<Esc>', [[<C-\><C-n>]], default_opts)

-- netrw (vinegar)
map('n', '<Leader>11', ':Explore<CR>', default_opts)
map('n', '<Leader>1v', ':Vexplore<CR>', default_opts)
map('n', '<Leader>1x', ':Sexplore<CR>', default_opts)
map('n', '<Leader>1t', ':Texplore<CR>', default_opts)

-- (b)uffer
map('n', '<Leader>bd', ':bdelete!<CR>', default_opts)
map('n', '<Leader>bb', ':ls<CR>:b<Space>', default_opts)

-- (5)ession
map('n', '<Leader>5s', ':SaveSession<CR>', default_opts)
map('n', '<Leader>l5', ':LoadSession<CR>', default_opts)
map('n', '<Leader>5d', ':DeleteSession<CR>', default_opts)

-- (4)genda (does 4 resemble A a little bit?)
vim.keymap.set({ 'n' }, '<Leader>4', require('utils').open_agenda, default_opts)

-- (h)opcsharp
local hopcsharp = require('plugins.hopcsharp')
vim.keymap.set({ 'n' }, '<Leader>hh', hopcsharp.hopcsharp_menu, default_opts)
vim.keymap.set({ 'n' }, '<Leader>hd', require('hopcsharp').hop_to_definition, default_opts)
vim.keymap.set({ 'n' }, '<Leader>hi', require('hopcsharp').hop_to_implementation, default_opts)

