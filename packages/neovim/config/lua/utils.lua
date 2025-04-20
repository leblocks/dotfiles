local os = require('os')

function attach_cur_buf_to_lsp_by_name(client_name)
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

function open_agenda()
    -- get path to agenda file
    local agenda_path = vim.fs.joinpath(os.getenv('OneDrive') or os.getenv('HOME') or os.getenv('USERPROFILE'), 'agenda.md')

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


