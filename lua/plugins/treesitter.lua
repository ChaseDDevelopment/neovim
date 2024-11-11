return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			-- List of parsers to install
			ensure_installed = { "lua", "markdown", "python", "javascript", "c_sharp", "yaml", "json", "markdown_inline", "typescript", "rust", "sql"},
			auto_install = true,
			-- Enable syntax highlighting
			highlight = {
				enable = true, -- false will disable the whole extension
			},

			-- Enable indentation based on treesitter
			indent = {
				enable = true,
			},
			additional_vim_regex_highlighting = false,
		})
	end,
}
