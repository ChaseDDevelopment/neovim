return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        dap.adapters.coreclr = {
            type = "executable",
            command = "/home/nebula/debugging_adapters/netcoredbg/netcoredbg",
            args = { "--interpreter=vscode" },
        }
        dap.configurations.cs = {
            {
                type = "coreclr",
                name = "launch - netcoredbg",
                request = "launch",
                program = function()
                    if vim.fn.confirm("Should I recompile first?", "&yes\n&no", 2) == 1 then
                        vim.g.dotnet_build_project()
                    end
                    return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
                end,
            },
        }
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exted.dapui_config = function()
            dapui.close()
        end

        vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint,  { desc = "Toggle Breakpoint" })
        vim.keymap.set("n", "<Leader>dc", dap.continue, {desc = "Start Debugger/Attach Debugger"})
        vim.keymap.set("n", "<F8>", dap.step_over, {desc = "Step Over"})
        vim.keymap.set("n", "<F7>", dap.step_into, {desc = "Step Into"})
    end,
}
