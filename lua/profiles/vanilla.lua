-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Maps
vim.keymap.set("i", "jk", "<Esc>")

-- Case-insensitive search, unless search includes capital letter
vim.o.ignorecase = true
vim.o.smartcase = true

-- Load plugins
require("packer").startup(function()
	-- print("hi from inside packer startup function")
end)
