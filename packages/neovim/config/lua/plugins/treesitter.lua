require('nvim-treesitter.configs').setup({
    highlight = { enable = false },
    ensure_installed = {
        "bash",
        "c_sharp",
        "dockerfile",
        "html",
        "javascript",
        "json",
        "lua",
        "powershell",
        "python",
        "sql",
        "typescript",
        "yaml"
    },
    additional_vim_regex_highlighting = false,
})

-- had to do it on windows machine
-- use clang to compile language grammar
if vim.loop.os_uname().sysname == "Windows_NT" then
    require('nvim-treesitter.install').compilers = { "clang", "gcc" }
end

-- set code folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

