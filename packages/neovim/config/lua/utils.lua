local os = require('os')


local M = {}

M.attach_cur_buf_to_lsp_by_name = function(client_name)
    local active_clients = vim.lsp.get_clients()
    for _, value in pairs(active_clients) do
        if value.name == client_name then
            -- check if current buffer already attached to the client
            -- 0 denotes current buffer
            if vim.lsp.buf_is_attached(0, value.id) then
                print("Current buffer already attached to " .. client_name .. " language server.")
            else
                -- attach!
                vim.lsp.buf_attach_client(0, value.id);
                print("Current buffer attached to " .. client_name .. " language server.")
            end
            -- stop iteration
            return
        end
    end
    -- if we didn't find desired language server, notify user
    print("Could not find " .. client_name .. " language server.")
end

M.open_agenda = function()
    -- get path to agenda file
    local agenda_path = vim.fs.joinpath(os.getenv('OneDrive') or os.getenv('HOME') or os.getenv('USERPROFILE'),
        'agenda.md')

    if nil == vim.loop.fs_stat(agenda_path) then
        print("no agenda file '" .. agenda_path .. "'")
        return
    end

    -- get the list of all buffers
    local buffers = vim.api.nvim_list_bufs()

    -- check if the file is already open in any buffer
    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == agenda_path then
            -- if the buffer is already open, focus it
            vim.api.nvim_set_current_buf(buf)
            return
        end
    end

    -- If the buffer is not open, open the file in a new buffer
    vim.api.nvim_command('edit ' .. agenda_path)
end


M.hopcsharp = {}

local hopcsharp = require('hopcsharp')
local db = hopcsharp.get_db()
local query = require('hopcsharp.database.query')
local dbutils = require('hopcsharp.database.utils')

local format_entry = function(entry)
    local type = dbutils.__get_type_name(entry.type)
    return string.format("%-12s %-50s %-50s %s %s", type, entry.name, entry.path, entry.row, entry.column)
end

local get_hopcsharp_picker = function(item_producer, item_formatter)
    item_formatter = item_formatter or format_entry
    return function()
        require('fzf-lua').fzf_exec(function(fzf_cb)
            coroutine.wrap(function()
                local co = coroutine.running()
                for _, entry in pairs(item_producer()) do
                    fzf_cb(item_formatter(entry), function() coroutine.resume(co) end)
                    coroutine.yield()
                end
                fzf_cb()
            end)()
        end, {
            actions = {
                ['default'] = function(selected)
                    local result = {}
                    for part in string.gmatch(selected[1], "([^ ]+)") do
                        table.insert(result, part)
                    end
                    require('hopcsharp.hop.utils').__hop(result[3], result[4] + 1, result[5])
                end
            }
        })
    end
end

M.hopcsharp.list_all = get_hopcsharp_picker(function() return db:eval(query.get_all_definitions) end)
M.hopcsharp.list_classes = get_hopcsharp_picker(function() return db:eval(query.get_definition_by_type, { type = dbutils.__types.CLASS }) end)
M.hopcsharp.list_interfaces = get_hopcsharp_picker(function() return db:eval(query.get_definition_by_type, { type = dbutils.__types.INTERFACE }) end)
M.hopcsharp.list_structs = get_hopcsharp_picker(function() return db:eval(query.get_definition_by_type, { type = dbutils.__types.STRUCT }) end)
M.hopcsharp.list_records = get_hopcsharp_picker(function() return db:eval(query.get_definition_by_type, { type = dbutils.__types.RECORD}) end)
M.hopcsharp.list_enums = get_hopcsharp_picker(function() return db:eval(query.get_definition_by_type, { type = dbutils.__types.ENUM }) end)
M.hopcsharp.list_methods = get_hopcsharp_picker(function() return db:eval(query.get_definition_by_type, { type = dbutils.__types.METHOD }) end)

return M
