return {
  'nvim-treesitter/nvim-treesitter',
  build = ":TSUpdate",
  config = function()
    require('nvim-treesitter.configs').setup {
      -- List of parsers to install
      ensure_installed = { "lua", "markdown", "python", "javascript", "c_sharp", "yaml", "json"},


      -- Enable syntax highlighting
      highlight = {
        enable = true,              -- false will disable the whole extension
        additional_vim_regex_highlighting = false,
      },

      -- Enable indentation based on treesitter
      indent = {
        enable = true,
      },
    }
  end
}
