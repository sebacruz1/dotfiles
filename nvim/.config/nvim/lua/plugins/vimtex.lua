return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		if vim.uv.os_uname().sysname == "Darwin" then
			vim.g.vimtex_view_method = "skim"
			vim.g.vimtex_view_skim_sync = 1
			vim.g.vimtex_view_skim_activate = 1
		else
			vim.g.vimtex_view_method = "zathura"
		end

		vim.g.vimtex_compiler_method = "latexmk"
		vim.g.vimtex_compiler_latexmk = {
			build_dir = "build",
			options = {
				"-pdf",
				"-shell-escape",
				"-interaction=nonstopmode",
				"-synctex=1",
			},
		}

		vim.g.vimtex_quickfix_mode = 0
		vim.g.vimtex_syntax_enabled = 0 -- lo maneja treesitter
		vim.g.vimtex_indent_enabled = 0 -- lo maneja treesitter

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "tex",
			callback = function(args)
				local opts = { buffer = args.buf, silent = true }
				vim.keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<cr>", opts)
				vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<cr>", opts)
				vim.keymap.set("n", "<leader>lc", "<cmd>VimtexClean<cr>", opts)
				vim.keymap.set("n", "<leader>le", "<cmd>VimtexErrors<cr>", opts)
			end,
		})
	end,
}
