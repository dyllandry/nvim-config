--------------------------------------------------------------------------------
-- Generic Options -------------------------------------------------------------
--------------------------------------------------------------------------------

vim.keymap.set('i', 'jk', '<Esc>')
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.scrolloff = 10
-- Ignore case unless capital letter in search.
vim.o.ignorecase = true; vim.o.smartcase = true;

-- Markdown file settings
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*.md',
    callback = function()
        vim.opt.wrap = true
        vim.opt.linebreak = true
    end
})

--------------------------------------------------------------------------------
-- Install lazy.nvim plugin manager --------------------------------------------
--------------------------------------------------------------------------------

-- If lazy is not in user's data directory, git clone it.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
-- Add lazy to runtimepath
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------------------------------------
-- Plugins ---------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Setup vim plugins using lazy
require("lazy").setup({
    -- Automatically set tab settings.
    -- Will set according to project's editorconfig file.
    'tpope/vim-sleuth',

    -- Comment plugin.
    -- Eventually want to add treesitter and integrate with
    -- "JoosepAlviste/nvim-ts-context-commentstring" to support commenting
    -- embedded languages like in vue components.
    { 'numToStr/Comment.nvim', config = true, lazy = false },

    -- File tree explorer.
    {
      'preservim/nerdtree',
      config = function ()
        vim.g.NERDTreeWinSize = 50
      end
    },
})

