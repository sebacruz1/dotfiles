return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
			scrollback = 1000,
			hide_numbers = true,
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			close_on_exit = true,
			shell = vim.o.shell,

			float_opts = {
				border = "curved",
				winblend = 0,
				highlights = {
					border = "Normal",
					background = "Normal",
				},
			},
		})

		function _G.set_terminal_keymaps()
			local opts = { buffer = 0 }

			vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)

			vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
			vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
			vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
			vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
			vim.keymap.set("t", "<C-s>", [[<C-\><C-n><cmd>1ToggleTerm<CR>]], opts)
		end

		vim.api.nvim_create_autocmd("TermOpen", {
			group = vim.api.nvim_create_augroup("toggleterm_keymaps", { clear = true }),
			pattern = "term://*",
			callback = function()
				set_terminal_keymaps()
			end,
		})
	end,

	keys = {
		{ "<M-t>", "<cmd>1ToggleTerm direction=float<CR>", desc = "Terminal Flotante (1)" },
		{ "<leader>hh", "<cmd>2ToggleTerm direction=horizontal<CR>", desc = "Terminal Horizontal (2)" },
		{ "<M-t>", "<cmd>1ToggleTerm direction=float<CR>", mode = "t", desc = "Cerrar Flotante" },
		{ "<leader>hh", "<cmd>2ToggleTerm direction=horizontal<CR>", mode = "t", desc = "Cerrar Horizontal" },
	},
}
