return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require("telescope").setup()

            -- set keymaps
            local keymap = vim.keymap

            keymap.set("n", "<leader>pf", "<cmd>Telescope find_files<cr>", { desc = 'Telescope find files' })
            keymap.set("n", "<leader>ps", "<cmd>Telescope git_files<cr>", { desc = 'Telescope git files' })
        end,
    },
}
