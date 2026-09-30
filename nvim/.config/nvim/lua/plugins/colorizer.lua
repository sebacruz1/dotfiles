return {
	{
		"catgoose/nvim-colorizer.lua",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("colorizer").setup({
				filetypes = {
					"*",
					-- En LaTeX no pintar nombres de colores (red, blue, ...) escritos en el texto
					tex = { names = false },
					plaintex = { names = false },
					bib = { names = false },
				},
			})
		end,
	},
}
