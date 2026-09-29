vim.pack.add({
    "https://github.com/KieranCanter/candela.nvim",
})

vim.keymap.set("n", "<leader>cu", "<Plug>CandelaUi", {
    desc = "Candela: Toggle UI",
})