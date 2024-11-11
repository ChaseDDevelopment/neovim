return {
	"nvimdev/lspsaga.nvim",
	config = function()
		require("lspsaga").setup({})
	end,
	depdendencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
}
