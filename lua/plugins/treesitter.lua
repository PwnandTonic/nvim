local nvim_treesitter = "https://github.com/nvim-treesitter/nvim-treesitter"

vim.pack.add({
    nvim_treesitter,
})

local ts = require("nvim-treesitter")

ts.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
})

ts.install({
    "bash",
    "c",
    "cpp",
    "cmake",
    "dockerfile",
    "go",
    "html",
    "java",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "powershell",
    "python",
    "query",
    "regex",
    "sql",
    "toml",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
})