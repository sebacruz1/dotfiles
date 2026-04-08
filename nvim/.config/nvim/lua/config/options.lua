local opt = vim.opt

-- apariencia
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.splitright = true
opt.splitbelow = true
opt.timeoutlen = 400
opt.scrolloff = 8
opt.cmdheight = 0
opt.laststatus = 3
opt.showmode = false
opt.wrap = false

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- tabs / indent
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.autoindent = true
opt.smartindent = true
opt.updatetime = 250

-- directorios de sistema
local state_dir = vim.fn.stdpath("state")
local dirs = {
	undo = state_dir .. "/undo//",
	backup = state_dir .. "/backup//",
}

for _, dir in pairs(dirs) do
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end
end

opt.undodir = dirs.undo
opt.backupdir = dirs.backup
opt.undofile = true

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		spacing = 4,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
	},
})
