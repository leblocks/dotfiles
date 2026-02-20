local M = {}

M.hopcsharp_menu = function()
    local lists = {
        { name = 'list all types', action = require('hopcsharp.pickers.fzf').all_definitions },
        { name = 'list classes', action = require('hopcsharp.pickers.fzf').class_definitions },
        { name = 'list interfaces', action = require('hopcsharp.pickers.fzf').interface_definitions },
        { name = 'list attributes', action = require('hopcsharp.pickers.fzf').attribute_definitions },
        { name = 'list methods', action = require('hopcsharp.pickers.fzf').method_definitions },
        { name = 'list enums', action = require('hopcsharp.pickers.fzf').enum_definitions },
        { name = 'list structs', action = require('hopcsharp.pickers.fzf').struct_definitions },
        { name = 'list records', action = require('hopcsharp.pickers.fzf').record_definitions },
        { name = 'list files', action = require('hopcsharp.pickers.fzf').source_files },
    }

    vim.ui.select(lists, {
        prompt = 'hopcsharp',
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
