
vim.cmd [[
    set completeopt=menu,menuone,noselect
]]

local cmp = require('cmp')

cmp.setup({
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
  }),
})

