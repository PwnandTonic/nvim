vim.pack.add({
    "https://github.com/stevearc/conform.nvim",
})

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        java = { "google-java-format" },
    },

    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
    },
})