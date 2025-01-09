return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    -- Define filetypes supported by Prettier
    local supported = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "vue",
      "svelte",
      "css",
      "scss",
      "html",
      "json",
      "yaml",
    }

    -- Ensure `opts.formatters_by_ft` exists
    opts.formatters_by_ft = opts.formatters_by_ft or {}

    -- Add Prettier for its supported filetypes
    for _, ft in ipairs(supported) do
      opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
      table.insert(opts.formatters_by_ft[ft], "prettier")
    end

    -- Add Ruff for Python
    opts.formatters_by_ft.python = opts.formatters_by_ft.python or {}
    table.insert(opts.formatters_by_ft.python, "ruff")

    -- Ensure `opts.formatters` exists
    opts.formatters = opts.formatters or {}

    -- Configure Prettier
    opts.formatters.prettier = {
      condition = function(_, ctx)
        local M = require("conform.util")
        return M.has_parser(ctx) and (vim.g.lazyvim_prettier_needs_config ~= true or M.has_config(ctx))
      end,
    }

    -- Configure Ruff with line length of 79
    opts.formatters.ruff = {
      prepend_args = { "--config", "line-length=79" },
    }

    return opts
  end,
}
