return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			local map = vim.keymap.set
			map("n", "<leader>t", builtin.find_files, { silent = true })
			map("n", "<leader>b", builtin.buffers, { silent = true })
			map("n", "<leader>rg", builtin.live_grep, { silent = true })
		end,
	},
}

