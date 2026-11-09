vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

local group = vim.api.nvim_create_augroup("seba_qol", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = group,
	pattern = "*",
	command = [[match ErrorMsg /\s\+$/]],
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
	callback = function()
		if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
			vim.cmd("silent! update")
		end
	end,
})

-- oldfiles: guardar solo archivos que realmente se abrieron en una ventana.
-- El LSP (rename, code actions, imports) lista buffers que nunca visitaste y terminan en shada.
-- Además se agregan a v:oldfiles al momento, para que <leader>b los muestre en la
-- misma sesión (v:oldfiles solo se lee de shada al arrancar).
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = group,
	callback = function(args)
		-- bufload() (lo que usa el LSP) dispara BufWinEnter en una ventana interna
		-- tipo "autocmd"; eso no cuenta como abrirlo. Tampoco las flotantes.
		if vim.fn.win_gettype() == "autocmd" or vim.api.nvim_win_get_config(0).relative ~= "" then
			return
		end
		local buf = args.buf
		vim.b[buf].visited = true

		local file = vim.api.nvim_buf_get_name(buf)
		if file == "" or vim.bo[buf].buftype ~= "" then
			return
		end
		local oldfiles = { file }
		for _, f in ipairs(vim.v.oldfiles) do
			if f ~= file then
				oldfiles[#oldfiles + 1] = f
			end
		end
		vim.v.oldfiles = oldfiles
	end,
})

-- Quita de la lista los buffers no visitados (shada ignora los no listados)
local function unlist_unvisited()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buflisted and not vim.b[buf].visited then
			vim.bo[buf].buflisted = false
		end
	end
end

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = group,
	callback = unlist_unvisited,
})

-- Escribir shada también al perder el foco: si tmux/el Mac matan nvim sin :q,
-- los recientes de la sesión no se pierden.
vim.api.nvim_create_autocmd({ "FocusLost", "VimSuspend" }, {
	group = group,
	callback = function()
		unlist_unvisited()
		pcall(vim.cmd, "wshada")
	end,
})

vim.api.nvim_set_hl(0, "YankFlash", { bg = "#fffff0", fg = "#000000" })
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Resaltar el texto copiado (yank)",
	group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({
			higroup = "YankFlash", -- El color del destello (puedes probar "Visual" o "CurSearch")
			timeout = 200, -- Cuánto dura el destello en milisegundos (200ms es suave)
		})
	end,
})

vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = "*",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "html", "css", "scss" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescriptreact", "tsx" },
	callback = function(args)
		local opts = { buffer = args.buf, noremap = true, silent = true }
		vim.keymap.set("n", "+", "<C-a>", vim.tbl_extend("force", opts, { desc = "Incrementar numero" }))
		vim.keymap.set("n", "<C-x>", "<C-x>", vim.tbl_extend("force", opts, { desc = "Decrementar numero" }))
	end,
})

-- LaTeX: ajuste de línea visual y movimiento por línea en pantalla (solo en buffers tex)
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "tex", "plaintex", "bib" },
	callback = function(args)
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true

		local opts = { buffer = args.buf, silent = true }
		vim.keymap.set({ "n", "v" }, "j", "gj", opts)
		vim.keymap.set({ "n", "v" }, "k", "gk", opts)
	end,
})
