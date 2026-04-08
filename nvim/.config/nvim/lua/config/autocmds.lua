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
