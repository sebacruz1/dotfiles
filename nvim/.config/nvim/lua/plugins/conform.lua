return {
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				format_on_save = function(bufnr)
					if vim.bo[bufnr].filetype == "php" then
						return { timeout_ms = 3000, lsp_format = "never" }
					end
					return { timeout_ms = 2000, lsp_format = "fallback" }
				end,
				formatters_by_ft = {
					php = { "pint" },
					javascript = { "prettierd" },
					javascriptreact = { "prettierd" },
					typescript = { "prettierd" },
					typescriptreact = { "prettierd" },
					json = { "prettierd" },
					css = { "prettierd" },
					scss = { "prettierd" },
					markdown = { "prettierd" },
					lua = { "stylua" },
				},
			})
		end,
	},
}
