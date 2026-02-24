return {
	{
		"norcalli/nvim-colorizer.lua",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("colorizer").setup(
				{ "*" },
				{
					RGB = true,
					RRGGBB = true,
					names = false,
					tailwind = true,
					rgb_fn = true,
					mode = "background",
				}
			)
		end,
	},
}
