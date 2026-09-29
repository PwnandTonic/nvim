vim.pack.add({
    {
        src = "https://github.com/obsidian-nvim/obsidian.nvim",
        version = vim.version.range("*"),
    },
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

local vault = vim.env.OBSIDIAN_VAULT

if not vault or vault == "" then
    vim.notify(
        "OBSIDIAN_VAULT is not set; Obsidian integration disabled",
        vim.log.levels.WARN
    )
else
    require("obsidian").setup({
        legacy_commands = false,

        workspaces = {
            {
                name = "notes",
                path = vault,
            },
        },

        picker = {
            name = "telescope.nvim",
        },

        -- render-markdown.nvim will handle the visual Markdown UI.
        ui = {
            enable = false,
        },
    })
end

require("render-markdown").setup({
    preset = "obsidian",

    completions = {
        lsp = {
            enabled = true,
        },
    },
})

local map = vim.keymap.set

-- Obsidian
map("n", "<leader>oo", "<cmd>Obsidian quick_switch<cr>", {
    desc = "Obsidian: Find note",
})

map("n", "<leader>os", "<cmd>Obsidian search<cr>", {
    desc = "Obsidian: Search vault",
})

map("n", "<leader>on", "<cmd>Obsidian new<cr>", {
    desc = "Obsidian: New note",
})

map("n", "<leader>ot", "<cmd>Obsidian today<cr>", {
    desc = "Obsidian: Today's note",
})

map("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", {
    desc = "Obsidian: Backlinks",
})

map("n", "<leader>og", "<cmd>Obsidian tags<cr>", {
    desc = "Obsidian: Tags",
})

map("n", "<leader>oa", "<cmd>Obsidian open<cr>", {
    desc = "Obsidian: Open in app",
})

-- Markdown rendering
map("n", "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", {
    desc = "Markdown: Toggle rendering",
})

map("n", "<leader>mp", "<cmd>RenderMarkdown preview<cr>", {
    desc = "Markdown: Preview",
})