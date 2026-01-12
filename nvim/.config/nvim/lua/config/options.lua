local opt = vim.opt

-- apariencia
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 200
opt.timeoutlen = 400
opt.scrolloff = 8

-- búsqueda
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- tabs / indent
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.autoindent = true
opt.smartindent = true

-- directorios de sistema
local state_dir = vim.fn.stdpath("state")
local dirs = {
	undo = state_dir .. "/undo//",
	swap = state_dir .. "/swap//",
	backup = state_dir .. "/backup//",
}

for _, dir in pairs(dirs) do
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end
end

opt.undodir = dirs.undo
opt.directory = dirs.swap
opt.backupdir = dirs.backup
opt.undofile = true -- Importante: habilita el guardado de undo persistente

-- integración y otros
-- opt.clipboard = "unnamedplus"
opt.showmode = false

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
