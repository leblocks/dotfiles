-- disable by default
vim.g.copilot_filetypes = { ["*"] = false }
-- Tab already used in cmp setup
vim.g.copilot_no_tab_map = true

require("CopilotChat").setup({
  debug = true,
})

