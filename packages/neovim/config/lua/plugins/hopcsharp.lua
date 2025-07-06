local hopcsharp = require('hopcsharp')
local hop_utils = require('hopcsharp.hop.utils')
local db_query = require('hopcsharp.database.query')
local db_utils = require('hopcsharp.database.utils')

local fzf_lua = require('fzf-lua')

local M = {}

-- TODO ui select with types menu


M.list_types = function()
    -- get database (connection is always opened)
    local db = hopcsharp.get_db()
    -- query to get all definitions
    fzf_lua.fzf_exec(function(fzf_cb)
        coroutine.wrap(function()
            local co = coroutine.running()
            for _, entry in pairs(db:eval(db_query.get_all_definitions)) do
                local type = db_utils.__get_type_name(entry.type)
                fzf_cb(string.format("%-12s %-50s %-50s %s %s", type, entry.name, entry.path, entry.row, entry.column),
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

return M

