local function complete_env_variables()
    local line = vim.api.nvim_get_current_line()
    local col = vim.fn.col('.') - 1
    local start = col

    -- like [0-9a-zA-Z_]
    while start > 0 and line:sub(start, start):match('[%w_]') do
        start = start - 1
    end

    local prefix = line:sub(start + 1, col)
    local matches = {}

    -- TODO check how it works on linux
    -- env variables there are case sensitive
    for env_name, _ in pairs(vim.fn.environ()) do
        local escaped = vim.pesc(prefix:upper())
        if prefix == '' or env_name:upper():find('^' .. escaped) ~= nil then
            -- if empty or matches prefix -> add to completions
            table.insert(matches, env_name)
        end
    end

    table.sort(matches)
    vim.fn.complete(start + 1, matches)
end

vim.keymap.set('i', '<C-x><C-e>', function()
    vim.schedule(complete_env_variables)
    return '<Ignore>'
end, { expr = true, silent = true })
