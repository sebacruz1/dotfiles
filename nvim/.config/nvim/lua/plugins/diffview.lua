return {
	"sindrets/diffview.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("diffview").setup()
	end,
	keys = {
		{
			"<leader>gh",
			"<cmd>DiffviewFileHistory<CR>",
		},
		{
			"<leader>gd",
			"<cmd>DiffviewOpen -- %<CR>",
		},
		{
			"<leader>gq",
			"<cmd>DiffviewFileHistory %<CR>",
		},
		{
			"<leader>gc",
			"<cmd>DiffviewClose<CR>",
		},
	},
}
