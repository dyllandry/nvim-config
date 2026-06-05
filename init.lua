-- 🥤 Refresher 🍟
-- "zo" to [o]pen fold
-- "zc" to [c]lose fold
-- "zr" to [r]ecursively open 1 level of folds
-- "zR" to [r]ecursively open all level of folds
-- "zm" to recursively [m]inimize 1 level of folds
-- "zM" to recursively [m]inimize all level of folds

-- Todo {{{
-- - [ ]try debugger UI https://github.com/rcarriga/nvim-dap-ui
-- - [ ] find a plugin for showing LSP stuff
--     - show symbols when I type
--     - toggle symbols shortcut
--     - show signature help when I start typing params
--     - toggle signature help shortcut
--     - show virtual text for lsp diagnostic when I do ]d and [d
--     - toggle show all diagnostic virtual text shortcut
--     - show num file diagnostics in status bar
--     - show numb workspace diagnostics in status bar
-- }}}

-- Fold markers {{{
vim.o.foldmethod = 'marker'
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
vim.keymap.set('n', '<leader>re', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition)
vim.keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition)
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
  -- TODO: Desperately trying to auto format on save with prettier.
  -- Top comment on this Reddit thread explains my current issue and how to solve:
  -- https://www.reddit.com/r/neovim/comments/17lqn1f/how_to_update_the_buffer_after_change_it_before/
  -- on_attach: Callback when client attaches to a buffer.
  -- on_attach = function (client, clientBufferNumber)
  --   vim.api.nvim_create_autocmd(
  --     'BufWritePre',
  --     {
  --       buffer = clientBufferNumber,
  --       callback = function(bufferInfo)
  --         local projectDir = client.config.root_dir
  --         local prettierPath = projectDir .. '/node_modules/prettier/cli.js'
  --         if vim.fn.filereadable(prettierPath) then
  --           -- print('found prettier');
  --           -- print(vim.inspect(buffer))
  --           os.execute('npx prettier -w ' .. bufferInfo.match)
  --         end
  --         -- vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
  --         -- result = vim.fn.readfile('')
  --         -- print(vim.inspect(result))
  --       end
  --     }
  --   )
  --   -- autocmd BufWritePre *.rs lua vim.lsp.buf.format({ async = false })
  --
  --   -- vim.keymap.set(
  --   --   'n',
  --   --   '<leader>f',
  --   --   function()
  --   --
  --   --   end,
  --   --   { buffer = true }
  --   -- )
  -- end,
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
  -- on_init: Callback after LSP initializes.
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
      },
      { bufnr = context.bufnr },
      function(_, r)
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

-- Lazy plugin configs {{{
require("lazy").setup({
  -- Order plugins by how simple their config is.
  'wsdjeg/vim-fetch',
  'tpope/vim-repeat',
  'tpope/vim-fugitive',
  'airblade/vim-gitgutter',
  'tpope/vim-sleuth',
  'tpope/vim-surround',
  'mfussenegger/nvim-dap',
  {
    'preservim/nerdtree',
    config = function ()
    vim.g.NERDTreeWinSize = 40
    end
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
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
      vim.keymap.set('n', '<leader>ss', builtin.lsp_document_symbols)
      vim.keymap.set('n', '<leader>sS', builtin.lsp_workspace_symbols)
    end
  },
})
-- }}}

-- On plugin loaded {{{
vim.api.nvim_create_autocmd('User', {
  pattern = 'LazyLoad',
  callback = function(event)
    -- vim-fugitive {{{
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
    -- debugger {{{
    if event.data == 'nvim-dap' then
      require("dap").adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {"/Users/dylan/dev/js-debug/src/dapDebugServer.js", "${port}"},
        }
      }
      require("dap").configurations.javascript = {
        {
          name = "Launch file",
          type = "pwa-node",
          request = "launch",
          outputCapture = "std",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          name = "Attach",
          type = "pwa-node",
          request = "attach",
          restart = true,
        },
        {
          name = "Launch file with Jest",
          type = "pwa-node",
          request = "launch",
          program = "${workspaceFolder}/node_modules/jest/bin/jest.js",
          args = {"--testTimeout=3600000", "${file}"},
          cwd = "${workspaceFolder}",
          outputCapture = "std",
        },
        {
          name = "npm run dev",
          type = "pwa-node",
          request = "launch",
          runtimeExecutable = "npm",
          runtimeArgs = { "run", "dev" },
          cwd = "${workspaceFolder}",
          outputCapture = "std",
          skipFiles = {
            "<node_internals>/**",
            "node_modules/**/*",
          },
        }
      },
      vim.keymap.set('n', '<F5>', function()
          require('dap').continue()
          require('dap').repl.open({ height = 10 })
      end)
      vim.keymap.set('n', '<F6>', function()
        require('dap').run_last()
        require('dap').repl.open({ height = 10 })
      end)
      vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
      vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
      vim.keymap.set('n', '<S-F11>', function() require('dap').step_out() end)
      vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end)
      vim.keymap.set('n', '<Leader>dc', function() require('dap').clear_breakpoints() end)
      vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
      vim.keymap.set('n', '<S-F5>', function()
        require('dap').terminate()
        require('dap').repl.close()
      end)
      vim.keymap.set({'n', 'v'}, '<Leader>dK', function()
        require('dap.ui.widgets').hover()
      end)
      vim.keymap.set('n', '<Leader>df', function()
        require('dap').focus_frame()
      end)
    end
    -- }}}
    -- harpoon {{{
    if event.data == 'harpoon' then
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<Leader>ha", function() harpoon:list():add() end)
      vim.keymap.set("n", "<Leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      vim.keymap.set("n", "<Leader>j", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<Leader>k", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<Leader>l", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<Leader>;", function() harpoon:list():select(4) end)

      -- Configure telescope to show harpooned files.
      local telescopeConfig = require("telescope.config").values
      local function toggle_telescope(harpoon_files)
          local file_paths = {}
          for _, item in ipairs(harpoon_files.items) do
              table.insert(file_paths, item.value)
          end

          require("telescope.pickers").new({}, {
              prompt_title = "Harpoon",
              finder = require("telescope.finders").new_table({
                  results = file_paths,
              }),
              previewer = telescopeConfig.file_previewer({}),
              sorter = telescopeConfig.generic_sorter({}),
          }):find()
      end
      vim.keymap.set(
        "n",
        "<Leader>sh",
        function() toggle_telescope(harpoon:list()) end,
        { desc = "Open harpoon window" }
      )
    end
    -- }}}
    -- vim-gitgutter {{{
    if event.data == 'vim-gitgutter' then
      -- Make gutter update faster after file changes. Default is 4s.
      vim.o.updatetime = 100
    end
    -- }}}
  end,
})
-- }}}
-- }}}

