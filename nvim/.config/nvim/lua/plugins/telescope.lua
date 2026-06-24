return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			local actions = require("telescope.actions")
			local utils = require("telescope.utils")

			telescope.setup({
				defaults = {
					path_display = { "smart" },
					preview = {
						treesitter = false,
					},
					file_ignore_patterns = {
						"%.DS_Store",
						"%.Trashes",
						"%.Spotlight%-V100",
						"%.fseventsd",
						"%.AppleDouble",
						"%.LSOverride",
						"vendor/",
						"storage/",
						"node_modules/",
						"%.next/",
						"%.git/",
						"Icon\r",
						"%._.*",
						"venv/",
						"%.venv/",
						"__pycache__/",
						"%.pyc$",
					},
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-c>"] = actions.close,
						},
					},
				},
				pickers = {
					oldfiles = {
						cwd_only = true,
					},
					find_files = {
						hidden = true,
					},
					live_grep = {
						additional_args = function(_)
							return { "--hidden" }
						end,
					},
				},
			})

			telescope.load_extension("fzf")

			local map = vim.keymap.set
			map("n", "<leader>t", builtin.find_files, { desc = "Buscar archivos en raíz", silent = true })
			map("n", "<leader>fb", builtin.buffers, { desc = "Ver buffers", silent = true })
			map("n", "<leader>rg", builtin.live_grep, { desc = "Live Grep", silent = true })
			map("n", "<leader>b", builtin.oldfiles, { desc = "Recientes (Proyecto)", silent = true })
			map("n", "<leader>gs", builtin.git_status, { desc = "Git: archivos cambiados", silent = true })
		end,
	},
}
