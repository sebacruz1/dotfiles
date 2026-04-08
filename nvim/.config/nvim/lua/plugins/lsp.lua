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
					"prettierd",
					"prettier",
					"stylua",
					"eslint_d",
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
					"emmet_ls",
					"eslint",
					"hyprls",
					"intelephense",
					"jdtls",
					"lua_ls",
					"pyright",
					"tailwindcss",
					"vtsls",
				},
			})
		end,
	},

	{
		"config.lsp-native",
		dir = vim.fn.stdpath("config"),
		dependencies = { "saghen/blink.cmp" },
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					local opts = { buffer = args.buf, silent = true }
					
					-- Keymaps generales
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					
					-- Comandos específicos para vtsls
					if client and client.name == "vtsls" then
						vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, opts)
						vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
						vim.keymap.set("n", "<leader>oi", function()
							vim.lsp.buf.code_action({
								apply = true,
								context = {
									only = { "source.organizeImports" },
									diagnostics = {},
								},
							})
						end, { buffer = args.buf, desc = "Organize Imports (No remove)" })
					end
				end,
			})

			local servers = {
				emmet_ls = {
					filetypes = { "html", "typescriptreact", "javascriptreact", "css", "scss" },
					on_attach = function(client, bufnr)
						vim.keymap.set("i", "<c-s>,", function()
							client.request(
								"textDocument/completion",
								vim.lsp.util.make_position_params(0, client.offset_encoding),
								function(_, result)
									if not result or not result.items or #result.items == 0 then
										return
									end
									local textEdit = result.items[1].textEdit
									if not textEdit then
										return
									end
									textEdit.newText = ""
									vim.lsp.util.apply_text_edits({ textEdit }, bufnr, client.offset_encoding)
								end,
								bufnr
							)
						end, { buffer = bufnr, desc = "Expand emmet" })
					end,
				},
				eslint = {
					settings = {
						workingDirectories = { mode = "auto" },
						format = false, -- Desactivar formato de eslint, usar prettier
					},
					on_attach = function(client, bufnr)
						-- Mostrar warnings de imports no usados pero no auto-fix
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							callback = function()
								-- Solo organizar imports, NO remover
								vim.lsp.buf.code_action({
									apply = true,
									context = {
										only = { "source.organizeImports" },
										diagnostics = {},
									},
								})
							end,
						})
					end,
				},
				hyprls = {},
				intelephense = {
					settings = { intelephense = { environment = { phpVersion = "8.2" } } },
				},
				jdtls = {},
				lua_ls = {
					on_attach = function(client)
						client.server_capabilities.documentFormattingProvider = false
					end,
					settings = {
						Lua = { diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty = false } },
					},
				},
				pyright = {},
				tailwindcss = {
					settings = {
						tailwindCSS = {
							classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
							lint = { cssConflict = "warning", invalidApply = "error" },
						},
					},
				},
				vtsls = {
					filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
					settings = {
						typescript = {
							inlayHints = {
								parameterNames = { enabled = "literals" },
								parameterTypes = { enabled = true },
								variableTypes = { enabled = true },
								propertyDeclarationTypes = { enabled = true },
								functionLikeReturnTypes = { enabled = true },
								enumMemberValues = { enabled = true },
							},
							suggest = {
								completeFunctionCalls = true,
							},
							preferences = {
								importModuleSpecifier = "relative",
								jsxAttributeCompletionStyle = "auto",
							},
							format = {
								organizeImportsIgnoreCase = false,
								organizeImportsCollation = "ordinal",
								organizeImportsNumericCollation = true,
							},
						},
						javascript = {
							inlayHints = {
								parameterNames = { enabled = "literals" },
								parameterTypes = { enabled = true },
								variableTypes = { enabled = true },
								propertyDeclarationTypes = { enabled = true },
								functionLikeReturnTypes = { enabled = true },
								enumMemberValues = { enabled = true },
							},
							suggest = {
								completeFunctionCalls = true,
							},
							preferences = {
								importModuleSpecifier = "relative",
								jsxAttributeCompletionStyle = "auto",
							},
							format = {
								organizeImportsIgnoreCase = false,
								organizeImportsCollation = "ordinal",
								organizeImportsNumericCollation = true,
							},
						},
						vtsls = {
							experimental = {
								completion = {
									enableServerSideFuzzyMatch = true,
								},
							},
						},
					},
				},
			}

			for server, config in pairs(servers) do
				config.capabilities = capabilities
				vim.lsp.config(server, config)
			end
			vim.lsp.enable(vim.tbl_keys(servers))
		end,
	},
}
