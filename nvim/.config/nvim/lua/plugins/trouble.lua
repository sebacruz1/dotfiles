return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "Trouble",
	opts = {
		modes = {
			diagnostics_buffer = {
				mode = "diagnostics",
				filter = { buf = 0 },
				groups = {
					{ "filename", format = "{file_icon} {filename} {count}" },
				},
			},
			diagnostics = {
				groups = {
					{ "filename", format = "{file_icon} {filename} {count}" },
				},
			},
		},
		focus = true,
		follow = true,
		indent_guides = true,
		auto_close = true,
		warn_no_results = false,
		open_no_results = false,
		win = {
			size = 0.35,
		},
	},
	keys = {
		{
			"<leader>dd",
			"<cmd>Trouble diagnostics_buffer toggle<cr>",
			desc = "Diagnósticos del buffer",
		},
		{
			"<leader>ds",
			"<cmd>Trouble symbols toggle focus=false<cr>",
			desc = "Símbolos del archivo",
		},
		{
			"<leader>dl",
			"<cmd>Trouble lsp_references toggle<cr>",
			desc = "Referencias LSP",
		},
	},
}
