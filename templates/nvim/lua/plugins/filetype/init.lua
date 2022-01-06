require("filetype").setup({
    overrides = {
        extensions = {
            py = "python",
        },
        complex = {
            [".*git/config"] = "gitconfig", -- Included in the plugin
        },
        shebang = {
            python = "python",
            python3 = "python",
            env = "python",
        },
    },
})
