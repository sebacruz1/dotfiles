return {
	"toppair/peek.nvim",
	event = { "VeryLazy" },
	build = "deno task build:fast",
	config = function()
		local peek = require("peek")
		peek.setup({
			auto_load = true,
			close_on_bdelete = true,
			syntax = true,
			theme = "dark",
			update_on_change = true,
			app = "firefox",
		})
		vim.api.nvim_create_user_command("PeekOpen", peek.open, {})
		vim.api.nvim_create_user_command("PeekClose", peek.close, {})
	end,
}
