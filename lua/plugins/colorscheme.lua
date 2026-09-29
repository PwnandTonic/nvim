vim.pack.add({
    "https://github.com/scottmckendry/cyberdream.nvim",
})

require("cyberdream").setup({
    variant = "muted",
    transparent = true,
    saturation = 0.8,
    italic_comments = true,
    terminal_colors = true,
    borderless_pickers = false,
})

vim.cmd("colorscheme cyberdream")