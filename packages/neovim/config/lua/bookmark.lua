-- provide simple persistent bookmarks
-- to files, super simple
-- store paths to bookmarked files in a file inside _state_ folder

local bookmark_store = vim.fs.joinpath(vim.fn.stdpath("state"), "bookmarks.txt")

local function log(message)
    print("bookmarks " .. message)
end

local function ensure_bookmarks_file_exists()
    -- ensure file will exist
    local file, error = io.open(bookmark_store, "a")

    if error ~= nil then
        log(error)
        return
    else
        file:close()
    end
end

local function get_bookmarks()
    ensure_bookmarks_file_exists()

    local bookmarks = {}
    for line in io.lines(bookmark_store) do
        table.insert(bookmarks, line)
    end

    return bookmarks
end

local function set_bookmarks(paths)
    ensure_bookmarks_file_exists()

    local file, error = io.open(bookmark_store, "w+")

    if error ~= nil then
        log(error)
        return
    end

    for _, path in ipairs(paths) do
        file:write(path, "\n")
    end

    file:close()
end

vim.api.nvim_create_user_command("BookmarkAdd", function()
    local bookmarks = get_bookmarks()
    table.insert(bookmarks, vim.fn.expand("%:p"))
    set_bookmarks(bookmarks)
end, {})

vim.api.nvim_create_user_command("BookmarkRemove", function()
    local path = vim.fn.expand("%:p")
    local bookmarks = get_bookmarks()
    local new_bookmarks = {}

    for _, bookmark in ipairs(bookmarks) do
        if bookmark ~= path then
            table.insert(new_bookmarks, bookmark)
        end
    end

    set_bookmarks(new_bookmarks)
end, {})

vim.api.nvim_create_user_command("BookmarkRemoveAll", function()
    set_bookmarks({})
end, {})

vim.api.nvim_create_user_command("BookmarkList", function()
    local bookmarks = get_bookmarks()
    vim.ui.select(bookmarks, {
        prompt = "Select bookmark to open:",
        format_item = function(item)
            return vim.fs.basename(item) .. " " .. item
        end,
    }, function(item)
        if item == nil then
            return
        end
        vim.api.nvim_command("edit " .. item)
    end)
end, {})
