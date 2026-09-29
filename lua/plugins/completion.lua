vim.pack.add({
    "https://github.com/saghen/blink.lib",
    "https://github.com/saghen/blink.cmp",
    "https://github.com/rafamadriz/friendly-snippets",
})

local cmp = require("blink.cmp")

cmp.build():pwait()

cmp.setup({
    keymap = {
        preset = "default",

        ["<Tab>"] = {
            "snippet_forward",
            "fallback",
        },

        ["<S-Tab>"] = {
            "snippet_backward",
            "fallback",
        },
    },

    completion = {
        documentation = {
            auto_show = true,
        },
    },

    sources = {
        default = {
            "lsp",
            "path",
            "buffer",
            "snippets",
        },
    },
})