return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "Trouble",
	opts = {
		focus = true,
		modes = {
			diagnostics = {
				groups = {
					{ "filename", format = "{file_icon} {filename} {count}" },
				},
			},
		},
		styles = {
			window = {
				border = "rounded",
			},
		},
	},
	keys = {
		{
			"<leader>dd",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Diagnósticos del Buffer (Trouble)",
		},
	},
}
