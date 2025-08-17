return {
  "folke/tokyonight.nvim",
  name = "tokyonight",
  priority = 1000, -- Ensure it's loaded early
  lazy = false,
  config = function()
    require("tokyonight").setup({
      style = "night", -- The darkest variant: storm, night, moon, day
      transparent = true, -- Enable transparent background
      terminal_colors = false, -- Disable setting terminal colors
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        -- Add styles for other groups if needed
      },
      dim_inactive = false, -- Disable dimming inactive windows
      -- No direct equivalent for show_end_of_buffer, but transparency might handle visibility
      -- No direct no_bold, no_italic, no_underline; styles are specified per group
      -- Integrations: TokyoNight enables many by default; specify if needed
      plugins = {
        -- Enable specific integrations similar to user's Catppuccin setup
        cmp = true,
        gitsigns = true,
        nvim_tree = true, -- Note: it's nvim_tree in TokyoNight, not nvimtree
        treesitter = true,
        notify = true,
        mini = true,
        -- For more, see https://github.com/folke/tokyonight.nvim#integrations
      },
      -- Empty overrides as in user's config
      on_colors = function(colors) end,
      on_highlights = function(highlights, colors) end,
    })

    -- Setup must be called before loading
    vim.cmd.colorscheme("tokyonight-night")
  end,
}
