local M = {}

local mapping = {}

local function map(list)
    local i = 1
    while i <= #list do
        if i == #list then
            mapping[list[i]] = list[1]
        else
            mapping[list[i]] = list[i + 1]
        end

        i = i + 1
    end
end

local function has_mapping(word)
    return mapping[word] ~= nil
end

map({ '[', ']' })
map({ '(', ')' })
map({ '{', '}' })
map({ '-', '+' })
map({ '<', '>' })
map({ '\'', '"' })
map({ '&&', '||' })
map({ 'or', 'and' })
map({ 'get', 'set' })
map({ 'on', 'off' })
map({ 'all', 'none' })
map({ 'allow', 'deny' })
map({ 'true', 'false' })
map({ '$True', '$False' })
map({ 'enable', 'disable' })
map({ 'Enable', 'Disable' })
map({ 'enabled', 'disabled' })
map({ 'Enabled', 'Disabled' })
map({ 'public', 'protected', 'private' })

M.toggle = function()
    local word_under_cursor = vim.fn.expand('<cword>')

    if has_mapping(word_under_cursor) then
        vim.api.nvim_command('normal! ciw' .. mapping[word_under_cursor])
        return
    end

    -- try to get replacement just for one character
    local coords = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_get_current_line()
    local character_under_cursor = line:sub(coords[2] + 1, coords[2] + 1)

    if has_mapping(character_under_cursor) then
        vim.api.nvim_command('normal! r' .. mapping[character_under_cursor])
        return
    end
end

return M

