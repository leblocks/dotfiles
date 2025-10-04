require("fzf-lua").setup({
    defaults = {
        file_icons = false,
    },

    winopts = {
        fullscreen = true,
        preview = {
            hidden = true,
        },
    },

    fzf_opts = {
        ["--layout"] = "default",
    },
})
