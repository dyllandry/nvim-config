--------------------------------------------------------------------------------
-- Introduction ----------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- I want to be good at neovim!
-- If I feel overwhelmed, try to simplify this config instead of restarting.

--------------------------------------------------------------------------------
-- Generic Options -------------------------------------------------------------
--------------------------------------------------------------------------------

vim.keymap.set('i', 'jk', '<Esc>')
vim.g.mapleader = ' '
-- Make tabs appear as 4 spaces wide.
vim.o.tabstop = 4
-- Show tabs and spaces.
vim.o.list = true
-- 'relativenumber' and 'number' configure left-side line numbers.
vim.opt.relativenumber = true; vim.opt.number = true
-- Ignore case when searching, unless the search has a capital.
vim.o.ignorecase = true; vim.o.smartcase = true

-- Markdown settings
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*.md',
    callback = function()
        vim.opt.wrap = true
        vim.opt.linebreak = true
        vim.o.breakindent = true
    end
})

local myModule = require("my-module")
myModule.setupLazyPluginManager()

--------------------------------------------------------------------------------
-- Setup plugins ---------------------------------------------------------------
--------------------------------------------------------------------------------

-- Setup vim plugins using the lazy plugin manager.
-- Where possible these plugins are ordered by configuration simplicity.
require("lazy").setup({
    'tpope/vim-repeat',
    -- The Git plugin
    'tpope/vim-fugitive',
    -- Automatically sets vim's tab settings to match the current file.
    'tpope/vim-sleuth',
    -- Plugin to easily surround text.
    'tpope/vim-surround',
    -- File tree explorer. Use the command `:NERDTree` to open it.
    {
      'preservim/nerdtree',
      config = function ()
        vim.g.NERDTreeWinSize = 30
      end
    },
    -- Color theme
    {
        "navarasu/onedark.nvim",
        priority = 1000,
        config = function()
            require('onedark').setup {
                style = 'light'
            }
            require('onedark').load()
        end
    },
    -- Fuzzy file finder, but can find other things too.
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('telescope').setup{
                defaults = {
                    file_ignore_patterns = { 'package%-lock%.json' },
                    mappings = {
                        i = {
                            -- This disables telescope's default mapping for
                            -- Ctrl-u in insert mode from scrolling the preview
                            -- window up. Instead, it will clear the prompt.
                            ["<C-u>"] = false
                        },
                    },
                    -- This will change the layout of telescope so it fits well
                    -- in skinny windows.
                    layout_strategy = 'vertical',
                    layout_config = {
                        preview_cutoff = 22
                    }
                }
            }
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
            vim.keymap.set('n', '<leader>sg', builtin.live_grep, {})
        end
    },
})

