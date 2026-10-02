vim.pack.add({
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/nvim-neotest/nvim-nio",
    "https://github.com/rcarriga/nvim-dap-ui",
})

local dap = require("dap")

local home = vim.uv.os_homedir()
local is_windows = vim.fn.has("win32") == 1
local path_separator = is_windows and "\\" or "/"

local dapui = require("dapui")

local lldb_dap = is_windows
    and "C:\\Program Files\\LLVM\\bin\\lldb-dap.exe"
    or "/usr/bin/lldb-dap"

dap.adapters.lldb = {
    type = "executable",
    command = lldb_dap,
    name = "lldb",
}

local python_debugger = is_windows
    and "C:\\Users\\Eric\\AppData\\Local\\Programs\\Python\\Python313\\python.exe"
    or vim.fs.joinpath(
        vim.uv.os_homedir(),
        ".local",
        "share",
        "nvim",
        "debugpy-venv",
        "bin",
        "python"
    )

dap.adapters.python = {
    type = "executable",
    command = python_debugger,
    args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch current file",
        program = "${file}",
        pythonPath = python_debugger,
    },
}

dap.configurations.cpp = {
    {
        name = "Launch executable",
        type = "lldb",
        request = "launch",

        program = function()
        return vim.fn.input(
            "Path to executable: ",
            vim.fn.getcwd() .. path_separator,
                            "file"
        )
        end,

        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
    },
}

dap.configurations.c = dap.configurations.cpp

dapui.setup()

-- Debugger controls
vim.keymap.set("n", "<leader>dc", dap.continue, {
    desc = "Debug: Continue",
})

vim.keymap.set("n", "<leader>dn", dap.step_over, {
    desc = "Debug: Step Over",
})

vim.keymap.set("n", "<leader>di", dap.step_into, {
    desc = "Debug: Step Into",
})

vim.keymap.set("n", "<leader>do", dap.step_out, {
    desc = "Debug: Step Out",
})

-- Breakpoints
vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, {
    desc = "Debug: Toggle Breakpoint",
})

vim.keymap.set("n", "<leader>B", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, {
    desc = "Debug: Conditional Breakpoint",
})

-- Debugger UI
vim.keymap.set("n", "<leader>du", function()
    dapui.toggle()
end, {
    desc = "Debug: Toggle UI",
})

-- Automatically open the UI when debugging starts
dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end

dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end

-- Automatically close the UI when debugging finishes
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end

dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end
