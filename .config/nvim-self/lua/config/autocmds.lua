-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- block change to a readonly file
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		if vim.bo.readonly then
			vim.bo.modifiable = false
			vim.bo.readonly = true
		end
	end,
})
