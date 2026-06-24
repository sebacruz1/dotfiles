return {
	"kndndrj/nvim-dbee",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	cmd = { "Dbee" },
	keys = {
		{
			"<leader>db",
			function()
				require("dbee").toggle()
			end,
			desc = "Toggle Dbee",
		},
		{
			"<leader>dc",
			function()
				local connections_file = vim.fn.expand("~/.config/dbee/connections.json")
				vim.fn.mkdir(vim.fn.fnamemodify(connections_file, ":h"), "p")
				vim.cmd("edit " .. connections_file)
			end,
			desc = "Editar conexiones Dbee",
		},
	},
	build = function()
		require("dbee").install()
	end,
	config = function()
		local dbee = require("dbee")
		local sources = require("dbee.sources")

		local connections_file = vim.fn.expand("~/.config/dbee/connections.json")
		vim.fn.mkdir(vim.fn.fnamemodify(connections_file, ":h"), "p")

		dbee.setup({
			sources = {
				sources.FileSource:new(connections_file),
			},
			editor = {
				directory = vim.fn.expand("~/.local/share/dbee/queries"),
			},
			result = {
				page_size = 100,
			},
		})
	end,
}
