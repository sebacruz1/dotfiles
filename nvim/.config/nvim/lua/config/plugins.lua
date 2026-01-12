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

vim.filetype.add({
	pattern = {
		[".*%.blade%.php"] = "blade",
	},
})

require("lazy").setup({
	-- --- Apariencia ---
	{
		"rebelot/kanagawa.nvim",
		name = "kanagawa",
		priority = 1000,
		config = function()
			vim.cmd("colorscheme kanagawa-dragon")
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
				view = {
					width = 30,
					side = "right",
				},
				renderer = { group_empty = true },
				git = { enable = true },
			})
			local map = vim.keymap.set
			map("n", "<leader>n", "<cmd>NvimTreeToggle<CR>", { silent = true })
			map("n", "<leader>f", "<cmd>NvimTreeFindFile<CR>", { silent = true })
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "^3.0.0",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
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

	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "*",
		opts = {
			keymap = {
				preset = "none",
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide" },
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },
			},
			completion = {
				ghost_text = { enabled = true },
				list = {
					selection = { preselect = true, auto_insert = false },
				},
				documentation = { auto_show = true, auto_show_delay_ms = 200 },
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
	},

	-- --- Treesitter ---
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

	-- --- LSP Nativo Neovim 0.11 + Mason ---
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	{ "neovim/nvim-lspconfig", enabled = true },

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim", "nvim-lspconfig" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"pyright",
					"intelephense",
					"vue_ls",
					"eslint",
					"hyprls",
					"vtsls",
					"emmet_ls",
					"tailwindcss",
				},
			})
		end,
	},

	{
		"config.lsp-native",
		dir = vim.fn.stdpath("config"),
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Autocmd para keymaps globales de LSP
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

			-- 1. Definir rutas de plugins (Vue support)
			local vue_plugin_path = vim.fn.stdpath("data")
				.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
			-- 2. Definir configuración de servidores
			local servers = {
				lua_ls = {
					on_attach = function(client)
						client.server_capabilities.documentFormattingProvider = false
					end,
					settings = {
						Lua = { diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty = false } },
					},
				},
				pyright = {},
				vue_ls = {
					init_options = {
						typescript = {},
					},
					on_attach = function(client)
						client.server_capabilities.semanticTokensProvider.full = true
					end,
				},
				vtsls = {
					filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
					settings = {
						vtsls = {
							tsserver = {
								globalPlugins = {
									{
										name = "@vue/typescript-plugin",
										location = vue_plugin_path,
										languages = { "vue" },
										configNamespace = "typescript",
									},
								},
							},
						},
					},
				},
				tailwindcss = {
					settings = {
						tailwindCSS = {
							classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
							lint = { cssConflict = "warning", invalidApply = "error" },
						},
					},
				},
				intelephense = {
					settings = { intelephense = { environment = { phpVersion = "8.2" } } },
				},
				emmet_ls = {
					filetypes = { "html", "typescriptreact", "javascriptreact", "css", "blade", "vue" },
					on_attach = function(client, bufnr)
						vim.keymap.set("i", "<c-s>,", function()
							client.request(
								"textDocument/completion",
								vim.lsp.util.make_position_params(0, client.offset_encoding),
								function(_, result)
									if not result or not result.items then
										return
									end
									local textEdit = result.items[1].textEdit
									local snip_string = textEdit.newText
									textEdit.newText = ""
									vim.lsp.util.apply_text_edits({ textEdit }, bufnr, client.offset_encoding)
									require("luasnip").lsp_expand(snip_string)
								end,
								bufnr
							)
						end, { buffer = bufnr, desc = "Expand emmet" })
					end,
				},
				hyprls = {},
				eslint = {},
			}

			-- 3. Cargar configuraciones en Neovim 0.11
			for server, config in pairs(servers) do
				config.capabilities = capabilities
				vim.lsp.config(server, config)
			end
			vim.lsp.enable(vim.tbl_keys(servers))
		end,
	},

	-- --- Formateo ---
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				format_on_save = function(bufnr)
					if vim.bo[bufnr].filetype == "php" then
						return { timeout_ms = 2000, lsp_fallback = false }
					end
					return { timeout_ms = 2000, lsp_fallback = true }
				end,
				formatters_by_ft = {
					php = { "pint" },
					blade = { "blade-formatter" },
					javascript = { "prettierd" },
					typescript = { "prettierd" },
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
