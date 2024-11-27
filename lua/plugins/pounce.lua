return {
    "rlane/pounce.nvim",
    config = function()
        require("pounce").setup({
            accept_keys = "NTESIROAGJKDFVBYMCXWPQZ",
            accept_best_key = "<enter>",
            multi_window = true,
            debug = false,
        })
        -- Keymaps for pounce.nvim
        vim.keymap.set("n", "s", function()
            require("pounce").pounce()
        end, { desc = "Jump to a location in the current buffer" })
        vim.keymap.set("n", "S", function()
            require("pounce").pounce({ do_repeat = true })
        end, { desc = "Repeat last jump with pounce" })
        vim.keymap.set("x", "s", function()
            require("pounce").pounce()
        end, { desc = "Jump to a location in visual mode" })
        vim.keymap.set("o", "gs", function()
            require("pounce").pounce()
        end, { desc = "Jump to a location in operator-pending mode" })
        vim.keymap.set("n", "S", function()
            require("pounce").pounce({ input = { reg = "/" } })
        end, { desc = "Use last search register with pounce" })
    end,
}

