return {
  "mfussenegger/nvim-dap",
  opts = function(_, opts)
    -- Ensure configurations table exists
    opts.configurations = opts.configurations or {}

    -- Function to parse launchSettings.json
    local function parse_launch_settings()
      local launch_file = "./Properties/launchSettings.json"
      if vim.fn.filereadable(launch_file) == 1 then
        local json = vim.fn.json_decode(vim.fn.readfile(launch_file))
        local profile = json.profiles and json.profiles.http -- Use `http` profile
        if profile then
          return {
            commandName = profile.commandName,
            launchBrowser = profile.launchBrowser,
            environmentVariables = profile.environmentVariables,
            applicationUrl = profile.applicationUrl,
            dotnetRunMessages = profile.dotnetRunMessages,
          }
        else
          print("Error: 'http' profile not found in launchSettings.json")
        end
      else
        print("Error: launchSettings.json not found")
      end
      return nil
    end

    -- Function to override .NET configurations
    local function setup_dotnet_dap()
      local settings = parse_launch_settings()
      if settings then
        -- Remove the default .NET configurations
        require("dap").configurations.cs = nil
        require("dap").configurations.cs = {
          {
            type = "coreclr",
            name = "Launch .NET Core",
            request = "launch",
            program = function()
              return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net8.0/SandyBox.dll", "file")
            end,
            args = {
              "--urls=" .. settings.applicationUrl, -- Ensure the application uses the correct URL
            },
            env = settings.environmentVariables,
            cwd = "${workspaceFolder}",
            stopAtEntry = false,
            console = "integratedTerminal",
          },
        }
        print("DAP configurations for .NET set successfully.")
      else
        print("Failed to parse launchSettings.json or profile not found.")
      end
    end

    -- Ensure default configurations are set up first
    local vscode = require("dap.ext.vscode")
    local json = require("plenary.json")
    vscode.json_decode = function(str)
      return vim.json.decode(json.json_strip_comments(str))
    end

    -- Hook into the LazyVim setup
    vim.schedule(function()
      setup_dotnet_dap()
    end)
  end,

  dependencies = {
    "rcarriga/nvim-dap-ui",
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },
  },

  keys = {
    { "<leader>d", "", desc = "+debug", mode = { "n", "v" } },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Breakpoint Condition",
    },
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Toggle Breakpoint",
    },
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      desc = "Run/Continue",
    },
    {
      "<leader>da",
      function()
        require("dap").continue({ before = get_args })
      end,
      desc = "Run with Args",
    },
    {
      "<leader>dC",
      function()
        require("dap").run_to_cursor()
      end,
      desc = "Run to Cursor",
    },
    {
      "<leader>dg",
      function()
        require("dap").goto_()
      end,
      desc = "Go to Line (No Execute)",
    },
    {
      "<leader>di",
      function()
        require("dap").step_into()
      end,
      desc = "Step Into",
    },
    {
      "<leader>dj",
      function()
        require("dap").down()
      end,
      desc = "Down",
    },
    {
      "<leader>dk",
      function()
        require("dap").up()
      end,
      desc = "Up",
    },
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "Run Last",
    },
    {
      "<leader>do",
      function()
        require("dap").step_out()
      end,
      desc = "Step Out",
    },
    {
      "<leader>dO",
      function()
        require("dap").step_over()
      end,
      desc = "Step Over",
    },
    {
      "<leader>dp",
      function()
        require("dap").pause()
      end,
      desc = "Pause",
    },
    {
      "<leader>dr",
      function()
        require("dap").repl.toggle()
      end,
      desc = "Toggle REPL",
    },
    {
      "<leader>ds",
      function()
        require("dap").session()
      end,
      desc = "Session",
    },
    {
      "<leader>dt",
      function()
        require("dap").terminate()
      end,
      desc = "Terminate",
    },
    {
      "<leader>dw",
      function()
        require("dap.ui.widgets").hover()
      end,
      desc = "Widgets",
    },
  },

  config = function()
    if LazyVim.has("mason-nvim-dap.nvim") then
      require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
    end

    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

    for name, sign in pairs(LazyVim.config.icons.dap) do
      sign = type(sign) == "table" and sign or { sign }
      vim.fn.sign_define(
        "Dap" .. name,
        { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
      )
    end
  end,
}
