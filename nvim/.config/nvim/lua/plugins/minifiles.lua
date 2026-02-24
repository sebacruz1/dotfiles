return {
	"echasnovski/mini.files",
	version = "*",
	config = function()
		require("mini.files").setup({
			windows = {
				width_focus = 30,
				width_preview = 50,
			},
		})
	end,
	keys = {
		{
			"-",
			function()
				require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
			end,
			desc = "Open Mini Files",
		},
	},
}
