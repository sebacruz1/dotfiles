vim.g.mapleader = ","
vim.g.maplocalleader = " "
local map = vim.keymap.set

-- básicos
map("n", "<leader>w", "<cmd>w<CR>", { silent = true })

local function smart_close_buffer()
	local listed_buffers = vim.fn.getbufinfo({ buflisted = 1 })

	if #listed_buffers <= 1 then
		vim.cmd("bd")
		pcall(vim.cmd, "Alpha")
	else
		vim.cmd("bd")
	end
end

map("n", ",q", smart_close_buffer, { desc = "Cerrar buffer o ir al inicio", silent = true })

map("n", "<leader>x", "<cmd>close<CR>")
map("n", "<localleader>q", "<cmd>qa<CR>")
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })

map("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Split + Buscar Archivo" })
map("n", "<leader>-", "<cmd>split<CR>", { desc = "Split + Buscar Archivo" })

map("n", "<leader>p", '"+p', { desc = "Pegar desde el sistema" })
map("i", "<C-v>", "<C-r>+", { desc = "Pegar desde el sistema en insertar" })

map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copiar al sistema" })

map("n", "q:", "<nop>")
map("n", "q/", "<nop>")
map("n", "q?", "<nop>")

-- smart-splits: navegar panes
map("n", "<C-h>", function()
	require("smart-splits").move_cursor_left()
end, { desc = "Move left" })
map("n", "<C-j>", function()
	require("smart-splits").move_cursor_down()
end, { desc = "Move down" })
map("n", "<C-k>", function()
	require("smart-splits").move_cursor_up()
end, { desc = "Move up" })
map("n", "<C-l>", function()
	require("smart-splits").move_cursor_right()
end, { desc = "Move right" })

-- smart-splits: resize panes
map("n", "<C-Left>", function()
	require("smart-splits").resize_left()
end, { desc = "Resize left" })
map("n", "<C-Right>", function()
	require("smart-splits").resize_right()
end, { desc = "Resize right" })
map("n", "<C-Up>", function()
	require("smart-splits").resize_up()
end, { desc = "Resize up" })
map("n", "<C-Down>", function()
	require("smart-splits").resize_down()
end, { desc = "Resize down" })
