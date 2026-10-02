vim.pack.add({
    "https://github.com/KieranCanter/candela.nvim"
})

require("candela").setup()

vim.keymap.set("n", "<leader>cu", "<Plug>CandelaUi")
