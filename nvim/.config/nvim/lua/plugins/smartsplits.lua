return {
	"smart-splits-nvim/smart-splits.nvim",
	-- no lazy load: el backend tiene que marcar @pane-is-vim en tmux al iniciar
	lazy = false,
	dependencies = {
		{ "smart-splits-nvim/backend-tmux", main = "smart-splits-backend-tmux" },
	},
	opts = {
		mux = { backend = "smart-splits-backend-tmux" },
	},
}
