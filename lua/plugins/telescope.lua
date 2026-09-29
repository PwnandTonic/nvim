vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",
})

require("telescope").setup({})

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, {
    desc = "Find files",
})

vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
    desc = "Live grep",
})

vim.keymap.set("n", "<leader>fb", builtin.buffers, {
    desc = "Find buffers",
})

vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, {
    desc = "Find symbols",
})