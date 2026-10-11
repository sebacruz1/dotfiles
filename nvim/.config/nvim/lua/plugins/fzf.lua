return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "FzfLua",
	init = function()
		-- Usa fzf-lua para vim.ui.select (code actions, etc.) cargándolo solo cuando se necesite
		---@diagnostic disable-next-line: duplicate-set-field
		vim.ui.select = function(...)
			require("fzf-lua").register_ui_select()
			return vim.ui.select(...)
		end
	end,
	keys = {
		{ "<leader>t", function() require("fzf-lua").files() end, desc = "Buscar archivos en raíz", silent = true },
		{ "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Ver buffers", silent = true },
		{ "<leader>rg", function() require("fzf-lua").live_grep() end, desc = "Live Grep", silent = true },
		{ "<leader>b", function() require("fzf-lua").oldfiles() end, desc = "Recientes (Proyecto)", silent = true },
		{ "<leader>gs", function() require("fzf-lua").git_status() end, desc = "Git: archivos cambiados", silent = true },
		{
			"<leader>lf",
			function()
				require("fzf-lua").files({
					prompt = "Archivos LaTeX> ",
					cmd = "rg --files --hidden -g '*.tex'",
				})
			end,
			desc = "Buscar archivos .tex",
			silent = true,
		},
	},
	---@module "fzf-lua"
	---@type fzf-lua.Config|{}
	---@diagnostic disable: missing-fields
	opts = {
		defaults = {
			formatter = "path.filename_first",
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
				"build/",
				"%.aux$",
				"%.log$",
				"%.out$",
				"%.toc$",
				"%.lof$",
				"%.lot$",
				"%.bbl$",
				"%.blg$",
				"%.bcf$",
				"%.run%.xml$",
				"%.fdb_latexmk$",
				"%.fls$",
				"%.synctex%.gz$",
				"%.nav$",
				"%.snm$",
				"%.vrb$",
				"%.xdv$",
			},
		},
		previewers = {
			builtin = {
				treesitter = { enabled = false },
			},
		},
		files = {
			hidden = true,
		},
		grep = {
			hidden = true,
		},
		oldfiles = {
			cwd_only = true,
		},
	},
	---@diagnostic enable: missing-fields
}
