return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
	config = function()
		require("diffview").setup({
			enhanced_diff_hl = true,
			use_icons = true,
			view = {
				merge_tool = {
					layout = "diff3_horizontal",
				},
			},
		})
	end,
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Abrir Diffview" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Historial del archivo actual" },
		{ "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Cerrar Diffview" },
	},
}
