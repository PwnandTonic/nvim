vim.pack.add({
    "https://github.com/lewis6991/gitsigns.nvim",
})

local gs = require("gitsigns")

gs.setup({
    signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
    },
})

vim.keymap.set("n", "]h", gs.next_hunk, {
    desc = "Next Git hunk",
})

vim.keymap.set("n", "[h", gs.prev_hunk, {
    desc = "Previous Git hunk",
})

vim.keymap.set("n", "<leader>hp", gs.preview_hunk, {
    desc = "Preview Git hunk",
})

vim.keymap.set("n", "<leader>hs", gs.stage_hunk, {
    desc = "Stage Git hunk",
})

vim.keymap.set("n", "<leader>hr", gs.reset_hunk, {
    desc = "Reset Git hunk",
})

vim.keymap.set("n", "<leader>hb", gs.blame_line, {
    desc = "Git blame line",
})