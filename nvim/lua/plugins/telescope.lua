--fuzzy finder
return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require("telescope").setup()

        -- set keymaps
        local keymap = vim.keymap

        keymap.set("n", "<leader>pf", "<cmd>Telescope find_files<cr>", { desc = 'Telescope find files' })
        keymap.set("n", "<leader>pg", "<cmd>Telescope git_files<cr>", { desc = 'Telescope git files' })
        keymap.set("n", "<leader>ps", "<cmd>Telescope live_grep<cr>", { desc = 'Telescope live grep' })
    end,
}