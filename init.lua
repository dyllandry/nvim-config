vim.keymap.set('i', 'jk', '<Esc>')
vim.opt.relativenumber = true
vim.opt.number = true

vim.api.nvim_create_autocmd('BufEnter', {
	pattern = '*.md',
	callback = function()
		vim.opt.wrap = true
		vim.opt.linebreak = true
	end
})
