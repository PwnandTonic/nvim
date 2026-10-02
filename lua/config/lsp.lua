vim.lsp.config("clangd", {
    cmd = { "clangd", "--background-index", "--clang-tidy" },

    filetypes = {
        "c",
        "cpp",
        "objc",
        "objcpp",
        "cuda",
    },

    root_markers = {
        "compile_commands.json",
        "compile_flags.txt",
        ".git",
    },
})

vim.lsp.enable("clangd")

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local map = vim.keymap.set
        local opts = { buffer = event.buf }

        map("n", "K", vim.lsp.buf.hover, opts)
        map("n", "gd", vim.lsp.buf.definition, opts)
        map("n", "gD", vim.lsp.buf.declaration, opts)
        map("n", "gi", vim.lsp.buf.implementation, opts)
        map("n", "gr", vim.lsp.buf.references, opts)

        map("n", "<leader>rn", vim.lsp.buf.rename, opts)
        map("n", "<leader>ca", vim.lsp.buf.code_action, opts)

        map("n", "<leader>d", vim.diagnostic.open_float, opts)
        map("n", "[d", vim.diagnostic.goto_prev, opts)
        map("n", "]d", vim.diagnostic.goto_next, opts)
    end,
})

local home = vim.uv.os_homedir()
local is_windows = vim.fn.has("win32") == 1

local lua_ls = is_windows
    and vim.fs.joinpath(
        home,
        "Tools",
        "lua-language-server",
        "bin",
        "lua-language-server.exe"
    )
    or vim.fs.joinpath(
        home,
        "Tools",
        "lua-language-server",
        "bin",
        "lua-language-server"
    )

vim.lsp.config("lua_ls", {
    cmd = { lua_ls },

    filetypes = { "lua" },

    root_markers = {
        ".luarc.json",
        ".luarc.jsonc",
        ".git",
    },

    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },

            diagnostics = {
                globals = {
                    "vim",
                },
            },

            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                },
                checkThirdParty = false,
            },

            telemetry = {
                enable = false,
            },
        },
    },
})

vim.lsp.enable("lua_ls")

vim.lsp.config("basedpyright", {
    cmd = { "basedpyright-langserver", "--stdio" },

    filetypes = { "python" },

    root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        ".git",
    },
})

vim.lsp.enable("basedpyright")
