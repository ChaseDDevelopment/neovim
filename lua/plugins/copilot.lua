local prompts = {
	-- Code related prompts
	Explain = "Please explain how the following code works.",
	Review = "Please review the following code and provide suggestions for improvement.",
	Tests = "Please explain how the selected code works, then generate unit tests for it.",
	Refactor = "Please refactor the following code to improve its clarity and readability.",
	FixCode = "Please fix the following code to make it work as intended.",
	FixError = "Please explain the error in the following text and provide a solution.",
	BetterNamings = "Please provide better names for the following variables and functions.",
	Documentation = "Please provide documentation for the following code.",
	SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
	SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
	-- Text related prompts
	Summarize = "Please summarize the following text.",
	Spelling = "Please correct any grammar and spelling errors in the following text.",
	Wording = "Please improve the grammar and wording of the following text.",
	Concise = "Please rewrite the following text to make it more concise.",
}
return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			"github/copilot.vim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			question_header = "## User",
			answer_header = "## Copilot",
			error_header = "## Error",
			prompts = prompts,
			auto_follow_cursor = false,
			window = {
				layout = "float",
				relative = "cursor",
				width = 1,
				height = 0.4,
				row = 1,
			},
			mappings = {
				-- Use tab for completion
				complete = {
					detail = "Use @<Tab> or /<Tab> for options.",
					insert = "<Tab>",
				},
				-- Close the chat
				close = {
					normal = "q",
					insert = "<C-c>",
				},
				-- Reset the chat buffer
				reset = {
					normal = "<C-x>",
					insert = "<C-x>",
				},
				-- Submit the prompt to Copilot
				submit_prompt = {
					normal = "<CR>",
					insert = "<C-CR>",
				},
				-- Accept the diff
				accept_diff = {
					normal = "<C-y>",
					insert = "<C-y>",
				},
				-- Yank the diff in the response to register
				yank_diff = {
					normal = "gmy",
				},
				-- Show the diff
				show_diff = {
					normal = "gmd",
				},
				-- Show the prompt
				show_system_prompt = {
					normal = "gmp",
				},
				-- Show the user selection
				show_user_selection = {
					normal = "gms",
				},
				-- Show help
				show_help = {
					normal = "gmh",
				},
			},
		},
		build = "make tiktoken",
		config = function(_, opts)
			local chat = require("CopilotChat")
			local select = require("CopilotChat.select")
			opts.selection = select.unamed

			chat.setup(opts)

			vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
				chat.ask(args.args, { selection = select.visual })
			end, { nargs = "*", range = true })

			-- Inline chat with Copilot
			vim.api.nvim_create_user_command("CopilotChatInline", function(args)
				chat.ask(args.args, {
					selection = select.visual,
					window = {
						layout = "float",
						relative = "cursor",
						width = 1,
						height = 0.4,
						row = 1,
					},
				})
			end, { nargs = "*", range = true })
			-- Custom buffer for CopilotChat
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-*",
				callback = function()
					vim.opt_local.relativenumber = true
					vim.opt_local.number = true

					-- Get current filetype and set it to markdown if the current filetype is copilot-chat
					local ft = vim.bo.filetype
					if ft == "copilot-chat" then
						vim.bo.filetype = "markdown"
					end
				end,
			})
		end,
		event = "VeryLazy",
		keys = {
			-- Show prompts actions with telescope
			{
				"<leader>gcpap",
				function()
					local actions = require("CopilotChat.actions")
					require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
				end,
				desc = "CopilotChat - Prompt actions",
			},
			{
				"<leader>gcpap",
				":lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))<CR>",
				mode = "x",
				desc = "CopilotChat - Prompt actions",
			},
			-- Code related commands
			{ "<leader>gcpae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
			{ "<leader>gcpat", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
			{ "<leader>gcpar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
			{ "<leader>gcpaR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
			{ "<leader>gcpan", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
			-- Chat with Copilot in visual mode
			{
				"<leader>gcpav",
				":CopilotChatVisual",
				mode = "x",
				desc = "CopilotChat - Open in vertical split",
			},
			{
				"<leader>gcpax",
				":CopilotChatInline<cr>",
				mode = "x",
				desc = "CopilotChat - Inline chat",
			},
			-- Custom input for CopilotChat
			{
				"<leader>gcpai",
				function()
					local input = vim.fn.input("Ask Copilot: ")
					if input ~= "" then
						vim.cmd("CopilotChat " .. input)
					end
				end,
				desc = "CopilotChat - Ask input",
			},
			-- Generate commit message based on the git diff
			{
				"<leader>gcpam",
				"<cmd>CopilotChatCommit<cr>",
				desc = "CopilotChat - Generate commit message for all changes",
			},
			-- Quick chat with Copilot
			{
				"<leader>gcpaq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						vim.cmd("CopilotChatBuffer " .. input)
					end
				end,
				desc = "CopilotChat - Quick chat",
			},
			-- Debug
			{ "<leader>gcpad", "<cmd>CopilotChatDebugInfo<cr>", desc = "CopilotChat - Debug Info" },
			-- Fix the issue with diagnostic
			{ "<leader>gcpaf", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - Fix Diagnostic" },
			-- Clear buffer and chat history
			{
				"<leader>gcpal",
				"<cmd>CopilotChatReset<cr>",
				desc = "CopilotChat - Clear buffer and chat history",
			},
			-- Toggle Copilot Chat Vsplit
			{ "<leader>gcpav", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
			-- Copilot Chat Models
			{ "<leader>gcpa?", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - Select Models" },
		},
	},
}
