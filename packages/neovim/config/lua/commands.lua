vim.api.nvim_create_user_command('ToggleStatusLine', function()
    vim.o.showmode = not vim.o.showmode
    vim.o.ruler = not vim.o.ruler
    vim.o.showcmd = not vim.o.showcmd
    vim.o.laststatus = vim.o.laststatus == 2 and 0 or 2
end, {})

vim.api.nvim_create_user_command('BufRemoveTrailingSpaces', function()
    vim.cmd([[:%s/\s\+$//e]])
end, {})

vim.api.nvim_create_user_command('BufSetUnixFileFormat', function()
    vim.cmd([[:set fileformat=unix]])
end, {})

vim.api.nvim_create_user_command('BufCopyPath', function()
    local path = vim.fn.expand('%:p')
    vim.fn.setreg('+', path)
    vim.notify('copied to clipboard ' .. path)
end, {})

vim.api.nvim_create_user_command('HopcsharpInitDatabase', function()
    require('hopcsharp').init_database()
end, {})

vim.api.nvim_create_user_command('HopcsharpShowDebugLog', function()
    local buf_name = 'hopcsharp://debug'
    local buffers = vim.api.nvim_list_bufs()

    -- check if debug log is already open in any buffer
    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == buf_name then
            -- if the buffer is already open - kill it
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end

    local debug = require('hopcsharp.debug')
    local db = debug.__get_db()

    local messages = db:eval(
        [[ select l.date, l.message from logs l where project = :project order by l.date desc ]],
        { project = vim.fn.getcwd() })

    if type(messages) ~= 'table' then
        return
    end

    local buffer_lines = {}
    for _, message in ipairs(messages) do
        table.insert(buffer_lines, string.format("[%s] %s", message.date, message.message))
    end

    local buf = vim.api.nvim_create_buf(true, true)

    vim.api.nvim_buf_set_name(buf, buf_name)
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, buffer_lines)
    vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
    vim.api.nvim_set_current_buf(buf)
end, {})

vim.api.nvim_create_user_command('VimPackUpdate', function()
    vim.pack.update()
end, {})

vim.api.nvim_create_user_command('VimPackExplore', function()
    vim.pack.update(nil, { offline = true })
end, {})
