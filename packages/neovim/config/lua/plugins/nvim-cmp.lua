vim.o.completeopt = 'menuone,noselect,longest,popup'

-- TODO try this for a little while, after that ditch nvim-cmp from config
-- https://georgebrock.github.io/talks/vim-completion/
-- TODO how to provide treesitter source? for usercomplete c-x c-u?
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

