local map = vim.keymap.set

map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })

map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

vim.keymap.set("n", "<leader>f", function()
    require("conform").format({
        async = true,
        lsp_format = "fallback",
    })
end, {
    desc = "Format buffer",
})

vim.keymap.set("n", "<leader>e", "<cmd>Explore<cr>", {
    desc = "File explorer",
})

-- Box drawing / tree characters
vim.keymap.set("i", ";;v", "│", { desc = "Box: vertical" })
vim.keymap.set("i", ";;h", "─", { desc = "Box: horizontal" })

vim.keymap.set("i", ";;b", "├── ", { desc = "Tree: branch" })
vim.keymap.set("i", ";;e", "└── ", { desc = "Tree: end branch" })

vim.keymap.set("i", ";;tl", "┌", { desc = "Box: top left" })
vim.keymap.set("i", ";;tr", "┐", { desc = "Box: top right" })
vim.keymap.set("i", ";;bl", "└", { desc = "Box: bottom left" })
vim.keymap.set("i", ";;br", "┘", { desc = "Box: bottom right" })

vim.keymap.set("i", ";;x", "┼", { desc = "Box: intersection" })