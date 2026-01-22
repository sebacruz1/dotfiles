return {
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				format_on_save = function(bufnr)
					if vim.bo[bufnr].filetype == "php" then
						return { timeout_ms = 3000, lsp_fallback = false }
					end
					return { timeout_ms = 2000, lsp_fallback = true }
				end,
				formatters_by_ft = {
					php = { "pint" },
					blade = { "blade-formatter" },
					javascript = { "prettierd", "eslint_d" },
					typescript = { "prettierd", "eslint_d" },
					vue = { "prettierd", "eslint_d" },
					lua = { "stylua" },
				},
			})
		end,
	},
}
