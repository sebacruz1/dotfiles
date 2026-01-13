return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local status, configs = pcall(require, "nvim-treesitter.configs")
			if not status then
				configs = require("nvim-treesitter")
			end

			configs.setup({
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"javascript",
					"typescript",
					"tsx",
					"json",
					"html",
					"css",
					"python",
					"bash",
					"markdown",
					"php",
					"blade",
					"vue",
					"scss",
				},
				highlight = { enable = true },
				indent = { enable = true },
				auto_install = true,
			})
		end,
	},
}
