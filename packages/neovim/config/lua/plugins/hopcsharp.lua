local hopcsharp = require("hopcsharp")
local hop_utils = require("hopcsharp.hop.utils")
local db_query = require("hopcsharp.database.query")
local db_utils = require("hopcsharp.database.utils")

local fzf_lua = require("fzf-lua")
local actions = fzf_lua.actions

local M = {}

local get_items_by_type = function(type)
    local db = hopcsharp.get_db()
    return function()
        return db:eval(db_query.get_definition_by_type, { type = type })
    end
end

local get_attributes = function()
    local db = hopcsharp.get_db()
    return db:eval(db_query.get_attributes)
end

local parse_entry = function(entry)
    local result = {}
    for part in string.gmatch(entry, "([^ ]+)") do
        table.insert(result, part)
    end

    if #result == 5 then
        return result[3], result[4] + 1, result[5]
    end

    return result[2], result[3] + 1, result[4]
end

local format_entry = function(entry)
    local type_name = db_utils.get_type_name(entry.type)
    return string.format("%-12s %-50s %-50s %s %s", type_name, entry.name, entry.path, entry.row, entry.column)
end

local format_entry_no_type = function(entry)
    return string.format("%-50s %s %s %s", entry.name, entry.path, entry.row, entry.column)
end

local get_picker = function(items_provider, formatter)
    local picker = function()
        -- get database (connection is always opened)
        fzf_lua.fzf_exec(function(fzf_cb)
            coroutine.wrap(function()
                local co = coroutine.running()
                local items = items_provider()

                if type(items) ~= "table" then
                    items = {}
                end

                for _, entry in pairs(items) do
                    fzf_cb(formatter(entry), function()
                        coroutine.resume(co)
                    end)
                    coroutine.yield()
                end
                fzf_cb()
            end)()
        end, {
            actions = {
                -- on select hop to definition by path row and column
                ["default"] = function(selected)
                    local path, row, column = parse_entry(selected[1])
                    hop_utils.__hop(path, row, column)
                end,

                ["ctrl-v"] = function(selected)
                    local path, row, column = parse_entry(selected[1])
                    hop_utils.__vhop(path, row, column)
                end,

                ["ctrl-s"] = function(selected)
                    local path, row, column = parse_entry(selected[1])
                    hop_utils.__shop(path, row, column)
                end,

                ["ctrl-t"] = function(selected)
                    local path, row, column = parse_entry(selected[1])
                    hop_utils.__thop(path, row, column)
                end,
            },

            fzf_opts = {
                ['--wrap'] = true,
            },
        })
    end

    return picker
end

local list_files = function()
    -- get database (connection is always opened)
    fzf_lua.fzf_exec(function(fzf_cb)
        coroutine.wrap(function()
            local db = hopcsharp.get_db()
            local co = coroutine.running()
            local items = db:eval([[ SELECT path FROM files ]])

            if type(items) ~= "table" then
                items = {}
            end

            for _, entry in pairs(items) do
                fzf_cb(entry.path, function()
                    coroutine.resume(co)
                end)
                coroutine.yield()
            end
            fzf_cb()
        end)()
    end, {
        actions = {
            ["enter"] = actions.file_edit_or_qf,
            ["ctrl-s"] = actions.file_split,
            ["ctrl-v"] = actions.file_vsplit,
            ["ctrl-t"] = actions.file_tabedit,
            ["alt-q"] = actions.file_sel_to_qf,
            ["alt-Q"] = actions.file_sel_to_ll,
            ["alt-i"] = actions.toggle_ignore,
            ["alt-h"] = actions.toggle_hidden,
            ["alt-f"] = actions.toggle_follow,
        },
    })
end

M.hopcsharp_menu = function()
    local lists = {
        {
            name = "list all types",
            action = get_picker(function()
                local db = hopcsharp.get_db()
                return db:eval(db_query.get_all_definitions)
            end, format_entry),
        },
        { name = "list classes",    action = get_picker(get_items_by_type(db_utils.types.CLASS), format_entry_no_type) },
        { name = "list interfaces", action = get_picker(get_items_by_type(db_utils.types.INTERFACE), format_entry_no_type) },
        { name = "list attributes", action = get_picker(get_attributes, format_entry_no_type) },
        { name = "list methods",    action = get_picker(get_items_by_type(db_utils.types.METHOD), format_entry_no_type) },
        { name = "list enums",      action = get_picker(get_items_by_type(db_utils.types.ENUM), format_entry_no_type) },
        { name = "list structs",    action = get_picker(get_items_by_type(db_utils.types.STRUCT), format_entry_no_type) },
        { name = "list records",    action = get_picker(get_items_by_type(db_utils.types.RECORD), format_entry_no_type) },
        { name = "list files",      action = list_files },
    }

    vim.ui.select(lists, {
        prompt = "hopcsharp",
        format_item = function(item)
            return item.name
        end,
    }, function(item)
        if item ~= nil then
            item.action()
        end
    end)
end

return M
