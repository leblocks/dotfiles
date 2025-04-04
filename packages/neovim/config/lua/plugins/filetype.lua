-- In init.lua or filetype.nvim's config file
require("filetype").setup({
    overrides = {
        extensions = {
            sh = "sh",
            csproj = "xml",
            props = "xml",
            targets = "xml",
            xml = "xml",
            resx = "xml",
            sqlproj = "xml",
            html = "html",
            sql = "sql",
        },
    },
})
