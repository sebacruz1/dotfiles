return {
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				hijack_netrw = true,
				view = {
					width = 30,
					side = "right",
				},
				renderer = { group_empty = true },
				git = { enable = true },
			})
			local map = vim.keymap.set
			map("n", "<leader>n", "<cmd>NvimTreeToggle<CR>", { silent = true })
			map("n", "<leader>f", "<cmd>NvimTreeFindFile<CR>", { silent = true })
		end,
	},
}
