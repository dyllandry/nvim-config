-- 🥤 Refresher 🍟
-- "zo" to [o]pen fold
-- "zc" to [c]lose fold
-- "zr" to [r]ecursively open 1 level of folds
-- "zR" to [r]ecursively open all level of folds
-- "zm" to recursively [m]inimize 1 level of folds
-- "zM" to recursively [m]inimize all level of folds

-- Fold markers {{{
vim.o.foldmethod = 'marker'
-- }}}

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
--         - " dr": [r]ename
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
vim.keymap.set('n', '<leader>dr', vim.lsp.buf.rename)
-- Depends on installing shellcheck and bash-language-server
vim.lsp.config['bash-language-server'] = {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'bash', 'sh' },
}
vim.lsp.enable('bash-language-server')
-- Vue lsp configuration was taken from https://github.com/vuejs/language-tools/wiki/Neovim
local typescript_language_server_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
local vue_language_server_path = '/Users/dylan/.nvm/versions/node/v20.19.4/lib/node_modules/@vue/language-server'
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}
vim.lsp.config['typescript-language-server'] = {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = typescript_language_server_filetypes,
    root_markers = { 'tsconfig.json' },
      init_options = {
        plugins = {
          vue_plugin,
        },
      },
}
local vue_ls_config = {
  cmd = { 'vue-language-server', '--stdio' },
  filetypes = { 'vue' },
  root_markers = { 'vite.config.js' },
  on_init = function(client)
    client.handlers['tsserver/request'] = function(_, result, context)
      local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'typescript-language-server' })
      if #clients == 0 then
        vim.notify('Could not find `vtsls` or `ts_ls` lsp client, `vue_ls` would not work without it.', vim.log.levels.ERROR)
        return
      end
      local ts_client = clients[1]
      local param = unpack(result)
      local id, command, payload = unpack(param)
      ts_client:exec_cmd({
        title = 'vue_request_forward',
        command = 'typescript.tsserverRequest',
        arguments = {
          command,
          payload,
        },
      }, { bufnr = context.bufnr }, function(_, r)
          local response = r and r.body
          local response_data = { { id, response } }
          ---@diagnostic disable-next-line: param-type-mismatch
          client:notify('tsserver/response', response_data)
        end)
    end
  end,
}
vim.lsp.config('vue_ls', vue_ls_config)
vim.lsp.enable({'typescript-language-server', 'vue_ls'})

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

