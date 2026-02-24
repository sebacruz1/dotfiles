vim.g.mapleader = ","
vim.g.maplocalleader = " "
local map = vim.keymap.set

-- básicos
map("n", "<leader>w", "<cmd>w<CR>", { silent = true })

--
local function smart_close_buffer()
	local listed_buffers = vim.fn.getbufinfo({ buflisted = 1 })

	if #listed_buffers <= 1 then
		vim.cmd("bd")
		pcall(vim.cmd, "Alpha")
	else
		vim.cmd("bd")
	end
end

vim.keymap.set("n", ",q", smart_close_buffer, { desc = "Cerrar buffer o ir al inicio", silent = true })

vim.keymap.set("n", "<leader>x", "<cmd>close<CR>")
vim.keymap.set("n", "<localleader>q", "<cmd>qa<CR>")
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })

vim.keymap.set("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Split + Buscar Archivo" })
vim.keymap.set("n", "<leader>-", "<cmd>split<CR>", { desc = "Split + Buscar Archivo" })



vim.keymap.set("n", "<leader>p", '"+p', { desc = "Pegar desde el sistema" })
vim.keymap.set("i", "<C-v>", "<C-r>+", { desc = "Pegar desde el sistema en insertar" })

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copiar al sistema" })

vim.keymap.set("n", "q:", "<nop>")
vim.keymap.set("n", "q/", "<nop>")
vim.keymap.set("n", "q?", "<nop>")
