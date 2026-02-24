return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = {
			[[                                    __ ]],
			[[         ,                    ," e`--o ]],
			[[        ((                   (  | __,' ]],
			[[         \\~----------------' \_;/     ]],
			[[    hjw  (                      /      ]],
			[[         /) ._______________.  )       ]],
			[[        (( (               (( (        ]],
			[[         ``-'               ``-'       ]],
		}

		dashboard.section.buttons.val = {
			dashboard.button("f", " Buscar archivo", ":Telescope find_files<CR>"),
			dashboard.button("r", " Archivos recientes", ":Telescope oldfiles<CR>"),
			dashboard.button("n", " Nuevo archivo", ":ene <BAR> startinsert <CR>"),
			dashboard.button("g", " Buscar texto", ":Telescope live_grep<CR>"),
			dashboard.button("c", " Editar configuracion", ":Telescope find_files cwd=~/Documents/dotfiles/<CR>"),
			dashboard.button("l", " Lazy", ":Lazy<CR>"),
			dashboard.button("G", " Estado de Git (Lazygit)", ":LazyGit<CR>"),
			dashboard.button("q", " Salir", ":qa<CR>"),
		}

		dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.buttons.opts.hl = "AlphaButton"
		dashboard.section.footer.opts.hl = "AlphaFooter"

		local stats = require("lazy").stats()
		dashboard.section.footer.val = "Cargados " .. stats.count .. " plugins en " .. stats.startuptime .. "ms"

		alpha.setup(dashboard.opts)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "alpha",
			callback = function()
				vim.opt_local.laststatus = 0
				vim.opt_local.showtabline = 0
			end,
		})
	end,
}
