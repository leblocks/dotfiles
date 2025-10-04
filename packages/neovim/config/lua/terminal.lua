local function terminal_config()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
end

local function get_current_buffer_directory()
    local directory = vim.fn.expand("%:p:h")
    -- terminal buffers have strange directory names
    if directory:find("term://") then
        return vim.uv.cwd()
    end
    return directory
end

local function launch_terminal(callback)
    local current_working_directory = vim.uv.cwd()
    local current_buffer_directory = get_current_buffer_directory()

    local commands = {
        {
            command = "pwsh -NoLogo -NoProfileLoadTime -WorkingDirectory " .. current_working_directory,
            description = "pwsh in cwd",
        },
        {
            command = "pwsh -NoLogo -NoProfileLoadTime -WorkingDirectory " .. current_buffer_directory,
            description = "pwsh in buffer folder",
        },
    }

    vim.ui.select(commands, {
        prompt = "Select terminal to launch:",
        format_item = function(item)
            return item.description
        end,
    }, function(item)
        if item == nil then
            return
        end
        callback(item.command)
    end)
end

local function close_terminal_buffers()
    for _, b in pairs(vim.api.nvim_list_bufs()) do
        local buf_name = vim.api.nvim_buf_get_name(b)
        if vim.api.nvim_buf_is_loaded(b) and buf_name:find("term://") then
            vim.api.nvim_buf_delete(b, { force = true })
        end
    end
end

local function format_terminal_name(terminal_buffer)
    local title = vim.fn.getbufvar(terminal_buffer, "term_title")
    local name = vim.api.nvim_buf_get_name(tonumber(terminal_buffer))
    if title ~= "" then
        return "(" .. tostring(title) .. ") " .. name
    end
    return name
end

local function select_terminal()
    local terminal_buffers = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= vim.api.nvim_get_current_buf() and vim.fn.getbufvar(buf, "&buftype") == "terminal" then
            table.insert(terminal_buffers, tostring(buf))
        end
    end

    vim.ui.select(terminal_buffers, {
        prompt = "Select terminal:",
        format_item = format_terminal_name,
    }, function(buf)
        if buf == nil then
            return
        end
        vim.api.nvim_set_current_buf(tonumber(buf))
    end)
end

vim.api.nvim_create_autocmd({ "TermOpen" }, {
    pattern = "*",
    callback = terminal_config,
    group = vim.api.nvim_create_augroup("terminal_config", { clear = true }),
})

vim.api.nvim_create_user_command("Terminal", function()
    launch_terminal(function(command)
        vim.cmd(":e term://" .. command)
    end)
end, {})

vim.api.nvim_create_user_command("TTerminal", function()
    launch_terminal(function(command)
        vim.cmd(":tabnew term://" .. command)
    end)
end, {})

vim.api.nvim_create_user_command("VTerminal", function()
    launch_terminal(function(command)
        vim.cmd(":vnew term://" .. command)
    end)
end, {})

vim.api.nvim_create_user_command("STerminal", function()
    launch_terminal(function(command)
        vim.cmd(":split term://" .. command)
    end)
end, {})

vim.api.nvim_create_user_command("CloseTerminals", function()
    close_terminal_buffers()
end, {})

vim.api.nvim_create_user_command("SelectTerminal", function()
    select_terminal()
end, {})
