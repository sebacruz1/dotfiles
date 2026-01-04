local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Detección de archivos Blade para Laravel
vim.filetype.add({
	pattern = {
		[".*%.blade%.php"] = "blade",
	},
})

require("lazy").setup({
	-- --- Apariencia ---
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd("colorscheme catppuccin-mocha")
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({ options = { globalstatus = true } })
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				hijack_netrw = true,
				view = { width = 35 },
				renderer = { group_empty = true },
				git = { enable = true },
			})
			local map = vim.keymap.set
			map("n", "<leader>n", "<cmd>NvimTreeToggle<CR>", { silent = true })
			map("n", "<leader>f", "<cmd>NvimTreeFindFile<CR>", { silent = true })
		end,
	},

	-- --- Navegación y Búsqueda ---
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			local map = vim.keymap.set
			map("n", "<leader>t", builtin.find_files, { silent = true })
			map("n", "<leader>b", builtin.buffers, { silent = true })
			map("n", "<leader>rg", builtin.live_grep, { silent = true })
		end,
	},

	-- --- Autocompletado Moderno (Blink.cmp) ---
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "*",
		opts = {
			keymap = { preset = "default" },
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
	},

	-- --- Treesitter (Corrección de carga segura) ---
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			-- Intenta cargar el módulo antiguo, si falla, usa el nuevo
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
				},
				highlight = { enable = true },
				indent = { enable = true },
				auto_install = true,
			})
		end,
	},

	-- --- LSP Nativo Neovim 0.11 + Mason ---
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	-- Habilitado para que mason-lspconfig valide nombres correctamente
	{ "neovim/nvim-lspconfig", enabled = true },

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim", "nvim-lspconfig" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"pyright",
					"intelephense",
					"vue_ls",
					"emmet_ls",
					"tailwindcss", -- 'volar' cambiado a 'vue_ls'
				},
			})
		end,
	},

	{
		"config.lsp-native",
		dir = vim.fn.stdpath("config"),
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local opts = { buffer = args.buf, silent = true }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				end,
			})

			-- Configuración de servidores con vue_ls
			local servers = {
				lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim" } } } } },
				ts_ls = {},
				pyright = {},
				vue_ls = {},
				tailwindcss = {},
				intelephense = {
					settings = {
						intelephense = {
							environment = { phpVersion = "8.2" },
						},
					},
				},
				emmet_ls = {
					filetypes = { "html", "typescriptreact", "javascriptreact", "css", "blade", "vue" },
				},
			}

			for server, config in pairs(servers) do
				config.capabilities = capabilities
				vim.lsp.config(server, config)
			end
			vim.lsp.enable(vim.tbl_keys(servers))
		end,
	},

	-- --- Formateo y Herramientas ---
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				format_on_save = { timeout_ms = 2000, lsp_fallback = true },
				formatters_by_ft = {
					javascript = { "prettierd" },
					typescript = { "prettierd" },
					javascriptreact = { "prettierd" },
					typescriptreact = { "prettierd" },
					vue = { "prettierd" },
					lua = { "stylua" },
				},
			})
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"gbprod/yanky.nvim",
		config = function()
			require("yanky").setup({})
			vim.keymap.set({ "n", "x" }, "<leader>y", "<Plug>(YankyPreviousEntry)")
			vim.keymap.set({ "n", "x" }, "<leader>Y", "<Plug>(YankyNextEntry)")
		end,
	},
}, {
	checker = { enabled = true },
})

