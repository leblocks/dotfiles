local M = {}

M.attach_cur_buf_to_lsp_by_name = function(client_name)
    local active_clients = vim.lsp.get_clients()
    for _, value in pairs(active_clients) do
        if value.name == client_name then
            -- check if current buffer already attached to the client
            -- 0 denotes current buffer
            if vim.lsp.buf_is_attached(0, value.id) then
                print('Current buffer already attached to ' .. client_name .. ' language server.')
            else
                -- attach!
                vim.lsp.buf_attach_client(0, value.id)
                print('Current buffer attached to ' .. client_name .. ' language server.')
            end
            -- stop iteration
            return
        end
    end
    -- if we didn't find desired language server, notify user
    print('Could not find ' .. client_name .. ' language server.')
end

return M
