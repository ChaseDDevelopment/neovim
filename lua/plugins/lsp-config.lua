return {

	{
		"williamboman/mason.nvim",
	},
	{
		"williamboman/mason-lspconfig.nvim",
	},

	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local lspconfig_defaults = require("lspconfig").util.default_config
			lspconfig_defaults.capabilities = vim.tbl_deep_extend(
				"force",
				lspconfig_defaults.capabilities,
				require("cmp_nvim_lsp").default_capabilities()
			)

			local function set_lsp_keymap(mode, lhs, rhs, desc, opts)
				opts = opts or {}
				opts.desc = desc -- Add description
				vim.keymap.set(mode, lhs, rhs, opts)
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }
					set_lsp_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", "Show hover info", opts)
					set_lsp_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition", opts)
					set_lsp_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to declaration", opts)
					set_lsp_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to implementation", opts)
					set_lsp_keymap(
						"n",
						"go",
						"<cmd>lua vim.lsp.buf.type_definition()<cr>",
						"Go to type definition",
						opts
					)
					set_lsp_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", "List references", opts)
					set_lsp_keymap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Show signature help", opts)
					set_lsp_keymap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename symbol", opts)
					set_lsp_keymap(
						{ "n", "x" },
						"<F3>",
						"<cmd>lua vim.lsp.buf.format({async = true})<cr>",
						"Format code",
						opts
					)
					set_lsp_keymap("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Show code actions", opts)
				end,
			})
			require("mason").setup({})
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({})
					end,
				},
			})
		end,
	},
}
