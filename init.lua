vim.keymap.set('i', 'jk', '<Esc>', { desc = 'exit insert mode'})

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.scrolloff = 4

vim.opt.wrap = false

vim.opt.tabstop = 2          -- Best descriptions of tabstop, softabstop, and shiftwidth I've found:
vim.opt.softtabstop = 2      -- https://arisweedler.medium.com/tab-settings-in-vim-1ea0863c5990#:~:text=tabstop%20is%20effectively%20how%20many,a%20backspace%20keypress%20is%20worth.
vim.opt.shiftwidth = 2       -- https://www.reddit.com/r/vim/comments/99ylz8/confused_about_the_difference_between_tabstop_and/

