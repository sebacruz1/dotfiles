vim.g.mapleader = ","
local map = vim.keymap.set

-- básicos
map("n", "<leader>w", "<cmd>w<CR>", { silent = true })
map("n", "<leader>q", "<cmd>q<CR>", { silent = true })
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { silent = true })

map("n", "<C-h>", "<C-w>h", { silent = true })
map("n", "<C-j>", "<C-w>j", { silent = true })
map("n", "<C-k>", "<C-w>k", { silent = true })
map("n", "<C-l>", "<C-w>l", { silent = true })

map("n", "<leader>co", "<cmd>copen<CR>", { silent = true })
map("n", "<leader>cc", "<cmd>cclose<CR>", { silent = true })
map("n", "]q", "<cmd>cnext<CR>", { silent = true })
map("n", "[q", "<cmd>cprev<CR>", { silent = true })
