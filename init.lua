if vim.fn.has("win32") == 1 then
    vim.opt.shellslash = false
end

-- Disable unused Neovim language providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.lsp")
require("config.java")

require("plugins.treesitter")
require("plugins.telescope")
require("plugins.completion")
require("plugins.snippets")
require("plugins.formatting")
require("plugins.git")
require("plugins.dap")
require("plugins.java")
require("plugins.candela")
require("plugins.colorscheme")
require("plugins.neo-tree")
require("plugins.notes")
