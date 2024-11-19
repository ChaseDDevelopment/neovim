return {
	"christoomey/vim-tmux-navigator",
	lazy = false,
	config = function()
        vim.keymap.set("n", "<C-H>", "<cmd> TmuxNavigateLeft<CR>", { desc = "window left" })
        vim.keymap.set("n", "<C-L>", "<cmd> TmuxNavigateRight<CR>", { desc = "window right" })
        vim.keymap.set("n", "<C-J>", "<cmd> TmuxNavigateDown<CR>", { desc = "window down" })
        vim.keymap.set("n", "<C-K>", "<cmd> TmuxNavigateUp<CR>", { desc = "window up" })
        vim.keymap.set("n", "<C-j>", "<C-d>zz")
vim.keymap.set("n", "<C-k>", "<C-u>zz")
	end,
	--	dependencies = {
	--		"nvim-lua/plenary.nvim",
	--	},
	--	config = function()
	--		local mark = require("hkarpoon.mark")
	--		local ui = require("harpoon.ui")
	--		vim.keymap.set("n", "<leader>a", mark.add_file)
	--		vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
	--		vim.keymap.set("n", "<C-a>", function()
	--			ui.nav_file(1)
	--		end)
	--		vim.keymap.set("n", "<C-s>", function()
	--			ui.nav_file(2)
	--		end)
	--		vim.keymap.set("n", "<C-d>", function()
	--			ui.nav_file(3)
	--		end)
	--		vim.keymap.set("n", "<C-f>", function()
	--			ui.nav_file(4)
	--		end)
	--	end,
}
