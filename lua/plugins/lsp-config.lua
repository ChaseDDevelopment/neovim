return {
	{
		'williamboman/mason.nvim',
		config = function()
			require('mason').setup()
		end
	},
	{
		'williamboman/mason-lspconfig.nvim',
		config = function()
			require('mason-lspconfig').setup({
				ensure_installed = {
					"lua_ls",
					"bashls",
					"tailwindcss",
					"cssls",
					"css_variables",
					"ast_grep",
					"dockerls",
					"eslint",
					"ts_ls",
					"biome",
					"grammarly",
					"harper_ls",
					"pylsp",
					"ruff",
					"ruff_lsp",
					"harper_ls",
					"rust_analyzer",
					"sqlls",
					"sqls",
					"yamlls"

				}
			})
		end
	},
	{
		'neovim/nvim-lspconfig',
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({})
			lspconfig.ts_ls.setup({})
			vim.keymap.set('n','K', vim.lsp.buf.hover, {})
			vim.keymap.set('n','gd', vim.lsp.buf.definition, {})
			vim.keymap.set({'n','v'}, '<leader>ca', vim.lsp.buf.code_action, {})
		end
	}
}
