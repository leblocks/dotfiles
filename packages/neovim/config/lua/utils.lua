function AttachCurrentBufferToLspClientByName(client_name)
    local active_clients = vim.lsp.get_active_clients()
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

function ToggleBackgroundColor()
    local background = vim.opt.background._value
    if background == "dark" then
        vim.opt.background = "light"
    else
        vim.opt.background = "dark"
    end
end

function ToggleStatusLine()
    vim.o.showmode = not vim.o.showmode
    vim.o.ruler = not vim.o.ruler
    vim.o.showcmd = not vim.o.showcmd
    vim.o.laststatus = vim.o.laststatus == 2 and 0 or 2
end

function CommonActions()
    local refactorings = {
        ['Remove trailing white spaces'] = function() vim.cmd([[:%s/\s\+$//e]]) end,
        ['Set unix fileformat'] = function() vim.cmd([[:set fileformat=unix]]) end,
        ['toggle; spell check'] = function() vim.cmd([[:set spell!]]) end,
        ['toggle: status line'] = ToggleStatusLine,
        ['toggle: background color'] = ToggleBackgroundColor,
    }

    local keys = {}
    for k, _ in pairs(refactorings) do
        table.insert(keys, k)
    end

    vim.ui.select(keys, { prompt = "Select refactoring to apply" },
        function(refactoring)
            refactorings[refactoring]()
        end)
end
