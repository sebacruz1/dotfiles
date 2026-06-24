return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",

	},
	opts = {
		workspaces = {
			{
				name = "ICI",
				path = "~/Documents/Vaults/ICI/",
			},
			{
				name = "Personal",
				path = "~/Documents/Vaults/Personal/",
			},
		},
	},
	attachments = {
		img_folder = "attachments",
	},
}
