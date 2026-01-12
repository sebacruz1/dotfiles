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

-- Guardar todos los buffers cuando se pierde el foco
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
	pattern = "*",
	callback = function()
		-- Verifica que el buffer tenga un nombre y haya sido modificado
		if vim.bo.modified and vim.fn.expand("%") ~= "" then
			vim.cmd("silent! wa")
		end
	end,
})
