-- Todo {{{
-- - [ ] find a plugin for showing LSP stuff
--     - show symbols when I type
--     - toggle symbols shortcut
--     - show signature help when I start typing params
--     - toggle signature help shortcut
--     - show virtual text for lsp diagnostic when I do ]d and [d
--     - toggle show all diagnostic virtual text shortcut
--     - show num file diagnostics in status bar
--     - show numb workspace diagnostics in status bar
-- - [ ] setup some own LSP shortcuts
--     - I like `<leader/space>d<letter>`.
--     - I relate "d" to LSPs because d means "diagnostics".
--         - " dd": go to [d]eclaration
--             - vim.lsp.buf.implementation()
--         - " dt": go to [t]ype declaration
--             - vim.lsp.buf.type_definition()
--         - " dfr": [f]ind [r]eferences
--             - vim.lsp.buf.references()
--         - " dcr": [c]ode action [r]ename
--             - vim.lsp.buf.rename()
--         - " dca": show [c]ode [a]ctions
--             - vim.lsp.buf.code_action()
--         - " ss": [s]earch [s]ymbols using telescope
--             - Telescope lsp_definitions
--             - There's probably other useful LSP searches.
--                 - Telescope lsp_document_symbols
--                 - Telescope lsp_references
-- }}}

-- Tabs {{{
-- Plugin vim-sleuth auto-detects tab settings for each file.
-- Default tab settings:
local tabsize = 4
local expandtab = false
-- Set the space-size of tabs.
vim.o.tabstop = tabsize
-- Set the space-size of auto-indent steps.
vim.o.shiftwidth = tabsize
-- Set the number of spaces inserted when the <Tab> key is pressed.
vim.o.softtabstop = tabsize
-- Replace insert mode tabs with spaces.
vim.o.expandtab = expandtab
-- }}}

-- Line numbers {{{
-- 'relativenumber' and 'number' configure left-side line numbers.
vim.opt.relativenumber = true;
vim.opt.number = true
-- }}}

-- Search using "/" {{{
-- Ignore case when searching, unless the search has a capital.
vim.o.ignorecase = true;
vim.o.smartcase = true
-- }}}

-- Other settings {{{
vim.keymap.set('i', 'jk', '<Esc>')
vim.g.mapleader = ' '
vim.o.foldmethod = 'marker'
-- }}}

-- Markdown settings {{{
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*.md',
    callback = function()
        -- vim.opt.wrap = true
        vim.opt.linebreak = true
        vim.o.breakindent = true
    end
})
-- }}}

-- LSP settings {{{
vim.lsp.config['typescript'] = {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'typescript' },
    root_markers = { 'tsconfig.json' },
}
vim.lsp.enable('typescript')
-- }}}

-- Plugins {{{
local myModule = require("my-module")
myModule.setupLazyPluginManager()

-- All plugin configs {{{
require("lazy").setup({
    -- Order plugins by how simple their config is.
    'wsdjeg/vim-fetch',
    'tpope/vim-repeat',
    'tpope/vim-fugitive',
    'airblade/vim-gitgutter',
    'tpope/vim-sleuth',
    'tpope/vim-surround',
    {
      'preservim/nerdtree',
      config = function ()
        vim.g.NERDTreeWinSize = 40
      end
    },
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
-- }}}

-- After plugins loaded {{{
vim.api.nvim_create_autocmd('User', {
  pattern = 'LazyLoad',
  callback = function(event)
    -- vim-fugitive settings {{{
    if event.data == 'vim-fugitive' then
      vim.api.nvim_create_user_command(
          -- I'd like to make this work for Git too but I don't know how.
          -- Last time I tried I caused infinite recursion.
          'G',
          function()
              vim.api.nvim_command('Git')
              vim.api.nvim_command('res 10')
          end,
          {}
      )
    end
    -- }}}
  end,
})
-- }}}
-- }}}

