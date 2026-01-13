return {
	{
		"kylechui/nvim-surround",
		version = "^3.0.0",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},

	{
		"gbprod/yanky.nvim",
		config = function()
			require("yanky").setup({})
			vim.keymap.set({ "n", "x" }, "<leader>y", "<Plug>(YankyPreviousEntry)")
			vim.keymap.set({ "n", "x" }, "<leader>Y", "<Plug>(YankyNextEntry)")
		end,
	},
}
