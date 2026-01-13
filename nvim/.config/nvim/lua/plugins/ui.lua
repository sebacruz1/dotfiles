return {
	{
		"rebelot/kanagawa.nvim",
		name = "kanagawa",
		priority = 1000,
		config = function()
			vim.cmd("colorscheme kanagawa-dragon")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({ options = { globalstatus = true } })
		end,
	},
}
