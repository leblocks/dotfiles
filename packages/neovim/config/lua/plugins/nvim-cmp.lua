
vim.cmd [[
    set completeopt=menu,menuone,noselect
]]

local cmp = require('cmp')

cmp.setup({
    formatting = {
        format = function(entry, vim_item)
            if entry.source.name == 'nvim_lsp' then
                vim_item.kind = vim_item.kind .. ' [LSP]'
            elseif entry.source.name == 'treesitter' then
                vim_item.kind = vim_item.kind .. ' [TRS]'
            elseif entry.source.name == 'buffer' then
                vim_item.kind = vim_item.kind .. ' [BUF]'
            elseif entry.source.name == 'tags' then
                vim_item.kind = vim_item.kind .. ' [TAG]'
            end

            return vim_item
        end
    },

    mapping = {
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        })
    },

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 30 },
        { name = 'treesitter', priority = 20 },
        { name = 'buffer', priority = 10 },
        { name = 'tags', priority = 40 },
    })
})

