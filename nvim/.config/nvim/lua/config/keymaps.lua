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

local function open_in_tmux_at_line(direction)
	local line = vim.fn.line(".")
	local file = vim.fn.expand("%:p")
	local flag = (direction == "vertical") and "-h" or "-v"

	-- Construcción del comando para nvim (neovim)
	local cmd = string.format('silent !tmux split-window %s "nvim -R +%d %s"', flag, line, file)
	vim.cmd(cmd)
end

-- Atajos de teclado
vim.keymap.set("n", "<leader>v", function()
	open_in_tmux_at_line("vertical")
end, { desc = "Tmux: Abrir actual a la derecha (RO + Línea)", silent = true })

vim.keymap.set("n", "<leader>h", function()
	open_in_tmux_at_line("horizontal")
end, { desc = "Tmux: Abrir actual abajo (RO + Línea)", silent = true })

-- Pegar desde el portapapeles del sistema (macOS) en modo normal
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Pegar desde el sistema" })

-- Pegar desde el portapapeles del sistema en modo insertar (como cmd + v)
vim.keymap.set("i", "<C-v>", "<C-r>+", { desc = "Pegar desde el sistema en insertar" })

-- Copiar explicitamente al sistema (solo cuando tú quieras)
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copiar al sistema" })

-- Ver el mensaje de error completo
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Ver error flotante" })

-- Navegación rápida entre errores
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Ir al error anterior" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Ir al siguiente error" })

-- Lista de todos los diagnósticos del proyecto (Quickfix list)
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setqflist, { desc = "Lista de errores del proyecto" })
