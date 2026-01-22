return {
	{
		"rebelot/kanagawa.nvim",
		name = "kanagawa",
		priority = 1000,
		opts = {
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
		config = function(_, opts)
			require("kanagawa").setup(opts)
			vim.cmd("colorscheme kanagawa-wave")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local colors = {
				bg = "#16161d",
				fg = "#dcd7ba",
				violet = "#957fb8",
			}

			local mode_style = { bg = colors.violet, fg = colors.bg, gui = "bold" }

			local uniform_theme = {
				normal = {
					a = mode_style,
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				insert = { a = mode_style },
				visual = { a = mode_style },
				replace = { a = mode_style },
				command = { a = mode_style },
				inactive = {
					a = { bg = colors.bg, fg = colors.fg },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
			}

			require("lualine").setup({
				options = {
					theme = uniform_theme,
					globalstatus = true,
					component_separators = { left = "|", right = "|" },
					section_separators = { left = "", right = "" },
				},
			})
		end,
	},
}
