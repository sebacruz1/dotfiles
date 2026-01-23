return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"pint",
					"blade-formatter",
					"prettierd",
					"prettier",
					"stylua",
					"eslint_d", -- Opcional, pero recomendado para linting rápido
				},
			})
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

			local vue_plugin_path = vim.fn.stdpath("data")
				.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

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
					filetypes = { "html", "typescriptreact", "javascriptreact", "css", "blade" },
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
									textEdit.newText = ""
									vim.lsp.util.apply_text_edits({ textEdit }, bufnr, client.offset_encoding)
								end,
								bufnr
							)
						end, { buffer = bufnr, desc = "Expand emmet" })
					end,
				},
				hyprls = {},
				eslint = {},
			}

			for server, config in pairs(servers) do
				config.capabilities = capabilities
				vim.lsp.config(server, config)
			end
			vim.lsp.enable(vim.tbl_keys(servers))
		end,
	},
}
