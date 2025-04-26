
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"

local session_folder = vim.fs.normalize(vim.fn.stdpath('state') .. '/sessions')

if vim.fn.isdirectory(session_folder) ~= 1 then
    print("TODO create session folder")
end

local function get_session_filepath()
    local session_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
    return vim.fs.joinpath(session_folder, session_name)
end

local function save_session()
    vim.cmd('mksession! ' .. get_session_filepath())
end

local function format_session_name(session_name)
    local name = vim.fn.fnamemodify(session_name, ':t')
    return name .. ' (' .. session_name .. ')'
end

local function load_session()
    local sessions = vim.split(vim.fn.glob(session_folder .. "/*"), '\n', { trimempty = true })
    vim.ui.select(sessions,
        {
            prompt = 'Select session to load:',
            format_item = format_session_name,
        },
        function(session_name)
            if (session_name ~= nil)
            then
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    vim.api.nvim_buf_delete(buf, { force = true })
                end

                vim.cmd('source ' ..  session_name)
            end
        end)
end

local function delete_session()
    local sessions = vim.split(vim.fn.glob(session_folder .. "/*"), '\n', { trimempty = true })
    vim.ui.select(sessions,
        {
            prompt = 'Select session to delete:',
            format_item = format_session_name,
        },
        function(session_name)
            if (session_name ~= nil)
            then
                vim.fn.delete(session_name, 'rf')
            end
        end)
end

vim.api.nvim_create_user_command('SaveSession', save_session, {})
vim.api.nvim_create_user_command('LoadSession', load_session, {})
vim.api.nvim_create_user_command('DeleteSession', delete_session, {})

