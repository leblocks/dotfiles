-- Custom quickfix text formatting function
-- copy pasted from internet and tweaked
local function quickfix_path_shortener(opts)
    local items = vim.fn.getqflist({ id = opts.id, items = 0 }).items
    local lines = {}

    for i = opts.start_idx, opts.end_idx do
        local item = items[i]
        if item then
            local filename = ''
            if item.bufnr > 0 then
                filename = vim.fs.basename(vim.fn.bufname(item.bufnr))
            end

            local lnum = item.lnum > 0 and item.lnum or ''
            local text = item.text or ''

            table.insert(lines, string.format('%-50s |%-5s| %s', filename, lnum, text))
        end
    end

    return lines
end

vim.o.quickfixtextfunc = 'v:lua.quickfix_path_shortener'

_G.quickfix_path_shortener = quickfix_path_shortener
