return {
	{
		"kylechui/nvim-surround",
		version = "^4.0.0",
		event = "VeryLazy",
	},
	{

		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true,
				ts_config = {
					lua = { "string" },
					javascript = { "template_string" },
					javascriptreact = { "template_string" },
					typescriptreact = { "template_string" },
				},
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = true,
			},
			aliases = {
				["javascriptreact"] = "html",
				["typescriptreact"] = "html",
			},
		},
	},
	{
		"itsfrank/swell.nvim",
		keys = {
			{ "<leader>m", "<cmd>SwellToggle<CR>", desc = "Toggle Swell" },
		},
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {},
	},
}
