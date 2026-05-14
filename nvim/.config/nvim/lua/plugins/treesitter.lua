return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter")
			local parsers = {
				"lua",
				"vim",
				"vimdoc",
				"java",
				"javascript",
				"typescript",
				"tsx",
				"json",
				"html",
				"css",
				"python",
				"bash",
				"markdown",
				"markdown_inline",
				"php",
				"scss",
			}

			treesitter.setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})
			if vim.fn.executable("tree-sitter") == 1 then
				treesitter.install(parsers):wait(300000)
			else
				vim.notify("nvim-treesitter: tree-sitter CLI not found; skipping parser install", vim.log.levels.WARN)
			end

			local filetypes = {
				"lua",
				"vim",
				"vimdoc",
				"java",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"tsx",
				"json",
				"html",
				"css",
				"python",
				"bash",
				"markdown",
				"php",
				"scss",
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = filetypes,
				callback = function()
					vim.treesitter.start()
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
}
