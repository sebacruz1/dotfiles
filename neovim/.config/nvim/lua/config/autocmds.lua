
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

vim.api.nvim_create_autocmd("FocusLost", {
  group = group,
  pattern = "*",
  command = [[silent! wa]],
})
