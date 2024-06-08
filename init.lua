--------------------------------------------------------------------------------
-- Generic Options -------------------------------------------------------------
--------------------------------------------------------------------------------

vim.keymap.set('i', 'jk', '<Esc>')
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.scrolloff = 10
-- Ignore case unless capital letter in search.
vim.o.ignorecase = true; vim.o.smartcase = true;
vim.g.mapleader = ' '
vim.o.tabstop = 4

-- Markdown file settings
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*.md',
    callback = function()
        vim.opt.wrap = true
        vim.opt.linebreak = true
        vim.o.breakindent = true
    end
})

-- Speeds up loading of nvim-ts-context-commentstring by skipping "backwards
-- compatibility routines".
vim.g.skip_ts_context_commentstring_module = true

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

    -- Plugin to easily surround text.
    'tpope/vim-surround',

    -- Comment plugin.
    {
        'numToStr/Comment.nvim',
        config = true,
        lazy = false,
        dependencies = "JoosepAlviste/nvim-ts-context-commentstring"
    },

    -- File tree explorer.
    {
      'preservim/nerdtree',
      config = function ()
        vim.g.NERDTreeWinSize = 50
      end
    },

    -- Fuzzy file finder over any lists. Made of pickers, sorters, and
    -- previewers, it can be used to find files, language server results, and
    -- more.
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
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

    -- onedark is a color scheme.
    {
        "navarasu/onedark.nvim",
        config = function()
            require('onedark').setup {
                style = 'warm'
            }
            require('onedark').load()
            -- I found when writing parenthesis in comments
            -- that when the matching paren was highlighted,
            -- the foreground and background colors were the
            -- same and the bracket would turn invisible.
            -- This command sets the background color of the
            -- matching parenthesis to a darker color.
            vim.cmd('hi MatchParen guibg=#444444')
        end
    },

    -- treesitter is a parsing system, it builds and updates syntax trees.
    -- It's possible to use treesitter with Nvim to have really intelligent
    -- syntax highlighting and stuff. I think Nvim comes with and installs
    -- treesitter. nvim-treesitter is a package that's meant to make using
    -- Nvim's treesitter interface easier. It makes setting up language
    -- parsers easy, and provides syntax highlighting based on those
    -- parser's output.
    {
        "nvim-treesitter/nvim-treesitter",
        -- Because each version of nvim-treesitter only works with specific
        -- parser versions, each time we install or update nvim-treesitter, we
        -- have to update all of our installed parsers.
        build = ":TSUpdate",
        config = function () 
            -- Just what nvim-treesitter makes you do to set configs, have to
            -- use this configs module and call .setup() on it.
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                -- Makes these get installed right away if they aren't
                -- installed yet. Like for example if you've opened nvim for
                -- the first time.
                ensure_installed = {
                    "typescript",
                    "javascript",
                    "html",
                    "css",
                    "vue",
                    "lua",
                },
                -- Enables the parsers to be installed and setup async so nvim
                -- still opens fast when first opened and parsers in
                -- ensure_installed aren't installed yet.
                sync_install = false,
                -- Enables highlighting based off the built syntax tree.
                highlight = { enable = true },
                -- Makes the = command indent the right number of tabs/spaces.
                indent = { enable = true },
            })
        end
        },

        -- nvim-ts-context-commentstring is a plugin that sets 'commentstring'
        -- depending on where the cursor is and uses treesitter. Seems
        -- redundant with Comment.nvim, but Comment.nvim itself didn't
        -- implement all the complicated logic for how to properly comment
        -- embedded languages in typescript. However, this plugin,
        -- nvim-ts-context-commentstring, did. I think the two plugins work
        -- together. This plugin is already installed by setting it as a
        -- dependency of other plugins, but put it here as as standalone plugin
        -- to centralize this comment.
        "JoosepAlviste/nvim-ts-context-commentstring"
})

