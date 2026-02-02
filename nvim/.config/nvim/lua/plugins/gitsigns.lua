return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		current_line_blame = true,

		-- Configuración visual
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			ignore_whitespace = false,
		},
		current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
	},
	keys = {
		{ "<leader>hh", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle Git Blame" },
		{ "<leader>hH", "<cmd>Gitsigns blame_line<cr>", desc = "Ver Blame completo de la línea" },
	},
}
