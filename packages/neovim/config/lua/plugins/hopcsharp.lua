local hopcsharp = require('hopcsharp')
local hop_utils = require('hopcsharp.hop.utils')
local db_query = require('hopcsharp.database.query')
local db_utils = require('hopcsharp.database.utils')

local fzf_lua = require('fzf-lua')

local M = {}

local get_items_by_type = function(type)
    local db = hopcsharp.get_db()
    return function() return db:eval(db_query.get_definition_by_type, { type = type }) end
end

local get_attributes = function()
    local db = hopcsharp.get_db()
    return db:eval(db_query.get_attributes)
end

local get_picker = function(items_provider)
    local picker = function()
        -- get database (connection is always opened)
        fzf_lua.fzf_exec(function(fzf_cb)
            coroutine.wrap(function()
                local co = coroutine.running()
                for _, entry in pairs(items_provider()) do
                    local type_name = db_utils.__get_type_name(entry.type)
                    fzf_cb(
                        string.format("%-12s %-50s %-50s %s %s", type_name, entry.name, entry.path, entry.row,
                            entry.column),
                        function() coroutine.resume(co) end)
                    coroutine.yield()
                end
                fzf_cb()
            end)()
        end, {
            actions = {
                -- on select hop to definition by path row and column
                ['default'] = function(selected)
                    local result = {}
                    for part in string.gmatch(selected[1], "([^ ]+)") do
                        table.insert(result, part)
                    end
                    hop_utils.__hop(result[3], result[4] + 1, result[5])
                end
            }
        })
    end

    return picker
end

M.hopcsharp_menu = function()
    local actions = {
        {
            name = 'list all types',
            action = get_picker(function()
                local db = hopcsharp.get_db()
                return db:eval(db_query.get_all_definitions)
            end),
        },
        { name = 'list classes',    action = get_picker(get_items_by_type(db_utils.__types.CLASS)), },
        { name = 'list interfaces', action = get_picker(get_items_by_type(db_utils.__types.INTERFACE)), },
        { name = 'list attributes', action = get_picker(get_attributes), },
        { name = 'list methods',    action = get_picker(get_items_by_type(db_utils.__types.METHOD)), },
        { name = 'list enums',      action = get_picker(get_items_by_type(db_utils.__types.ENUM)), },
        { name = 'list structs',    action = get_picker(get_items_by_type(db_utils.__types.STRUCT)), },
        { name = 'list records',    action = get_picker(get_items_by_type(db_utils.__types.RECORD)), },

    }

    vim.ui.select(actions,
        {
            prompt = 'hopcsharp',
            format_item = function(item) return item.name end,
        },
        function(item)
            if (item ~= nil)
            then
                item.action()
            end
        end)
end

return M
