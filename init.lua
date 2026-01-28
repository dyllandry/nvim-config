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
    --
    -- -- Comment plugin.
    -- {
    --     'numToStr/Comment.nvim',
    --     config = true,
    --     lazy = false,
    --     dependencies = "JoosepAlviste/nvim-ts-context-commentstring"
    -- },
    --

    -- Code formatter for JavaScript. Integrates with none-ls to enable
    -- formatting through nvim's lsp format function.
    -- {
    --     'MunifTanjim/prettier.nvim',
    --     opts = {
    --         bin = 'prettierd',
    --         filetypes = {
    --             "javascript",
    --             "typescript",
    --             "vue"
    --         }
    --     }
    -- },

    -- -- Show diff signs in sign column
    -- {
    --     'airblade/vim-gitgutter',
    --     config = function()
    --         -- Always show column to prevent jumping when signs appear.
    --         vim.o.signcolumn = "yes"
    --         -- Shorten time it takes for signs to appear.
    --         vim.o.updatetime = 100
    --     end
    -- },

    -- Provides access to a catalog of json schemas that are used by other plugins to
    -- provide autocomplete while writing json and yaml.
    -- "b0o/schemastore.nvim",

    -- none-ls (continuation of deprecated project null-ls) allows non-lsp
    -- tools to integrate with nvim's lsp functionality. For example, a non-lsp
    -- tool like a spell checker could integrate with nvim's lsp client
    -- diagnostics and appear next to diagnostics provided by real lsp servers.
    -- {
    --     'nvimtools/none-ls.nvim',
    --     dependencies = { 'nvim-lua/plenary.nvim' },
    --     config = function()
    --         local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
    --         local event = "BufWritePre" -- or "BufWritePost"
    --         local async = event == "BufWritePost"
    --         require('null-ls').setup({
    --             on_attach = function(client, bufnr)
    --                 if client.supports_method("textDocument/formatting") then
    --                     -- format on key press
    --                     -- Don't use volar for formatting. Current way of formatting with only prettier.
    --                     local filter_out_volar = function(client) return client.name ~= "volar" end
    --                     vim.keymap.set("n", "<Leader>f", function()
    --                         vim.lsp.buf.format({
    --                                 bufnr = vim.api.nvim_get_current_buf(),
    --                                 filter = filter_out_volar
    --                             })
    --                     end, { buffer = bufnr, desc = "[lsp] format" })
    --                     -- format on save
    --                     vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
    --                     vim.api.nvim_create_autocmd(event, {
    --                         buffer = bufnr,
    --                         group = group,
    --                         callback = function()
    --                             vim.lsp.buf.format({ bufnr = bufnr, async = async, filter = filter_out_volar })
    --                         end,
    --                         desc = "[lsp] format on save",
    --                     })
    --                 end
    --                 -- format range
    --                 if client.supports_method("textDocument/rangeFormatting") then
    --                     vim.keymap.set("x", "<Leader>f", function()
    --                         vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
    --                     end, { buffer = bufnr, desc = "[lsp] format" })
    --                 end
    --             end,
    --         })
    --     end
    -- },



    -- treesitter is a parsing system, it builds and updates syntax trees.
    -- It's possible to use treesitter with Nvim to have really intelligent
    -- syntax highlighting and stuff. I think Nvim comes with and installs
    -- treesitter. nvim-treesitter is a package that's meant to make using
    -- Nvim's treesitter interface easier. It makes setting up language
    -- parsers easy, and provides syntax highlighting based on those
    -- parser's output.
    -- {
    --     "nvim-treesitter/nvim-treesitter",
    --     -- Because each version of nvim-treesitter only works with specific
    --     -- parser versions, each time we install or update nvim-treesitter, we
    --     -- have to update all of our installed parsers.
    --     build = ":TSUpdate",
    --     config = function () 
    --         -- Just what nvim-treesitter makes you do to set configs, have to
    --         -- use this configs module and call .setup() on it.
    --         local configs = require("nvim-treesitter.configs")
    --         configs.setup({
    --             -- Makes these get installed right away if they aren't
    --             -- installed yet. Like for example if you've opened nvim for
    --             -- the first time.
    --             ensure_installed = {
    --                 "typescript",
    --                 "javascript",
    --                 "html",
    --                 "css",
    --                 "vue",
    --                 "lua",
    --                 "vimdoc"
    --             },
    --             -- Enables the parsers to be installed and setup async so nvim
    --             -- still opens fast when first opened and parsers in
    --             -- ensure_installed aren't installed yet.
    --             sync_install = false,
    --             -- Enables highlighting based off the built syntax tree.
    --             highlight = { enable = true },
    --             -- Makes the = command indent the right number of tabs/spaces.
    --             -- indent = { enable = true },
    --         })
    --     end
    -- },

    -- nvim-ts-context-commentstring is a plugin that sets 'commentstring'
    -- depending on where the cursor is and uses treesitter. Seems
    -- redundant with Comment.nvim, but Comment.nvim itself didn't
    -- implement all the complicated logic for how to properly comment
    -- embedded languages in typescript. However, this plugin,
    -- nvim-ts-context-commentstring, did. I think the two plugins work
    -- together. This plugin is already installed by setting it as a
    -- dependency of other plugins, but put it here as as standalone plugin
    -- to centralize this comment.
    -- "JoosepAlviste/nvim-ts-context-commentstring",

    -- -- nvim-lspconfig: Nvim supports the Language Server Protocol (LSP). If you
    -- -- have language servers available on your computer, then Nvim can connect
    -- -- to them and provide cool features like jumping to definition, renaming,
    -- -- etc. Nvim has to be configured for each language server, which can be
    -- -- hard to configure it correctly, so this plugin nvim-lspconfig provides
    -- -- some ready-to-go configs. You can checkout `:help lspconfig-all` to see
    -- -- the list of configurations, and installation instructions to get the
    -- -- respective language server on your computer.
    -- {
    --     'neovim/nvim-lspconfig',
    --     dependencies = { 'hrsh7th/cmp-nvim-lsp' },
    --     config = function()
    --         -- Makes it so that if you have multiple LSPs reporting
    --         -- diagnostics, the virtual text that appears on the buffer, and
    --         -- the floating window that shows when you jump to a diagnostic,
    --         -- both show the source of the diagnostic.
    --         vim.diagnostic.config({
    --             virtual_text = { source = true },
    --             float = { source = 'always' }
    --         })
    --         local lspconfig = require('lspconfig')
    --         lspconfig.volar.setup({})
    --         lspconfig.dockerls.setup({})
    --         lspconfig.bashls.setup({})
    --         lspconfig.terraformls.setup({})
    --         -- nvim-cmp supports more LSP capabilities than omnifunc. We will want to inform
    --         -- language servers of this. I'm not sure for which language servers I'm supposed
    --         -- to provide this.
    --         local nvim_cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
    --         lspconfig.eslint.setup({ capabilities = nvim_cmp_capabilities })
    --         lspconfig.marksman.setup({ capabilities = nvim_cmp_capabilities })
    --         lspconfig.jsonls.setup {
    --             capabilities = nvim_cmp_capabilities,
    --             settings = {
    --                 json = {
    --                     schemas = require('schemastore').json.schemas(),
    --                     validate = { enable = true },
    --                 },
    --             },
    --         }
    --         lspconfig.yamlls.setup {
    --             capabilities = nvim_cmp_capabilities,
    --             settings = {
    --                 yaml = {
    --                     schemaStore = {
    --                         -- From SchemaStore docs:
    --                         -- You must disable built-in schemaStore support if you want to use
    --                         -- this plugin and its advanced options like `ignore`.
    --                         enable = false,
    --                         -- From SchemStore docs:
    --                         -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
    --                         url = "",
    --                     },
    --                     schemas = require('schemastore').yaml.schemas(),
    --                 },
    --             },
    --         }
    --         lspconfig.ts_ls.setup({
    --             init_options = {
    --                 plugins = {
    --                     {
    --                         name = "@vue/typescript-plugin",
    --                         -- Could compute this with `nvm which <node version>` + /../../lib/ ...
    --                         -- Must be same version as volar
    --                         -- This location depends on operating system. Linux is /home/dylan while macos is /Users/dylan
    --                         location = "/Users/dylan/.nvm/versions/node/v18.20.2/lib/node_modules/@vue/typescript-plugin",
    --                         languages = {"javascript", "typescript", "vue"},
    --                     },
    --                 },
    --             },
    --             filetypes = {
    --                 "javascript",
    --                 "typescript",
    --                 "vue",
    --             },
    --             handlers = {
    --                 ["textDocument/publishDiagnostics"] = function(
    --                     _,
    --                     result,
    --                     ctx,
    --                     config
    --                 )
    --                     if result.diagnostics ~= nil then
    --                         local idx = 1
    --                         while idx <= #result.diagnostics do
    --                             if result.diagnostics[idx].code == 80001 then
    --                                 table.remove(result.diagnostics, idx)
    --                             else
    --                                 idx = idx + 1
    --                             end
    --                         end
    --                     end
    --                     vim.lsp.diagnostic.on_publish_diagnostics(
    --                         _,
    --                         result,
    --                         ctx,
    --                         config
    --                     )
    --                 end,
    --             },
    --         })
    --         -- vim.lsp.enable('vtsls')
    --         -- vim.lsp.enable('vue_ls')
    --         -- Disabled 2024/07/06 to limit complexity while I'm getting things
    --         -- working again. Next will probably just get TS working, then
    --         -- follow instructions for vue support. I think instructions
    --         -- changed since the last time this nvim config was written.
    --         -- LSP for Vue 3
    --         -- lspconfig.volar.setup {
    --         --     -- Turns on 'Take Over Mode' so volar becomes the language
    --         --     -- server for TypeScript files and can provide proper
    --         --     -- support for .vue files imported into TypeScript files.
    --         --     filetypes = {
    --         --         'typescript',
    --         --         'javascript',
    --         --         'javascriptreact',
    --         --         'typescriptreact',
    --         --         'vue',
    --         --         'json'
    --         --     },
    --         --     init_options = {
    --         --         typescript = {
    --         --             -- Some projects I use volar in that are js projects
    --         --             -- don't have typescript as a dependency, so here I
    --         --             -- point volar to use a globally installed typescript.
    --         --             -- Should see if I can do node/**/bin in file path so
    --         --             -- it can use any version. Or make a version that uses
    --         --             -- the current node version from nvm in the file path.
    --         --             tsdk = '/Users/dylan/.nvm/versions/node/v19.6.1/lib/node_modules/typescript/lib'
    --         --         }
    --         --     },
    --         --     -- Hides tsserver's specific diagnostic hint to convert
    --         --     -- commonjs modules to es6 modules.
    --         --     -- https://www.reddit.com/r/neovim/comments/nv3qh8/comment/h1tx1rh/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
    --         --     handlers = {
    --         --         ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
    --         --             if result.diagnostics ~= nil then
    --         --                 local idx = 1
    --         --                 while idx <= #result.diagnostics do
    --         --                     if result.diagnostics[idx].code == 80001 then
    --         --                         table.remove(result.diagnostics, idx)
    --         --                     else
    --         --                         idx = idx + 1
    --         --                     end
    --         --                 end
    --         --             end
    --         --             vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
    --         --         end,
    --         --     },
    --         --     capabilities = nvim_cmp_capabilities
    --         -- }
    --         -- Below we register keymaps after Nvim attaches to a language server.
    --         -- This autocmd will run whenever the LspAttach event fires.
    --         vim.api.nvim_create_autocmd('LspAttach', {
    --             -- Puts this autocmd in a group. Useful for organizing
    --             -- and using the group name as an identifier to later
    --             -- remove them. :help autocmd-groups
    --             group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    --             -- This is the event handler when the autocommand runs.
    --             callback = function(ev)
    --                 -- The LspAttach event includes which buffer was attached.
    --                 -- We can use this buffer number when registering keymaps
    --                 -- to make the keymap only work in that buffer.
    --                 local options = { buffer = ev.buf }
    --                 vim.keymap.set('n', 'gd', vim.lsp.buf.definition, options)
    --                 vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, opts)
    --                 vim.keymap.set('n', 'K', vim.lsp.buf.hover, options)
    --                 vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, options)
    --                 -- References are anywhere a symbol appears. Shows a list
    --                 -- of symbol occurences informed by usage provided by the
    --                 -- language server. Upon navigating, puts the cursor on the
    --                 -- occurence.
    --                 vim.keymap.set('n', 'gr', vim.lsp.buf.references, options)
    --                 -- The implementation is where a symbol is used. If you do
    --                 -- it on a base class, shows a list of derived classes. If
    --                 -- you do it on a type, shows a list of variables with that
    --                 -- type. Upon navigating, puts the cursor on the symbol
    --                 -- which implements the original symbol.
    --                 vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, options)
    --                 vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, options)
    --                 vim.keymap.set(
    --                     { 'n', 'v' },
    --                     '<Leader>ca',
    --                     vim.lsp.buf.code_action,
    --                     options
    --                 )
    --                 vim.keymap.set({ 'n' }, ']d', vim.diagnostic.goto_next, options)
    --                 vim.keymap.set({ 'n' }, '[d', vim.diagnostic.goto_prev, options)
    --                 -- Disabled for now, not sure if this is my desired behaviour.
    --                 -- vim.keymap.set(
    --                 --     'n',
    --                 --     '<Leader>f',
    --                 --     function()
    --                 --         vim.lsp.buf.format { async = true }
    --                 --     end,
    --                 --     opts
    --                 -- )
    --                 -- This was a TODO from previous nvim configuration.
    --                 -- TODO: install, configure, test
    --                 -- require("lsp_signature").on_attach({}, ev.buf)
    --             end,
    --         })
    --     end
    -- },
    -- Autocompletion plugin. It's the fancy window that automatically appears and as
    -- you type and fills with suggestions. A replacement of vim's omnifunc manual
    -- completion tool.
    -- For it to work "completion sources" must be installed and "sourced". nvim-cmp
    -- will handle the rest.
    -- {
    --     'hrsh7th/nvim-cmp',
    --     dependencies = {
    --         -- LSP source for nvim-cmp. Lets nvim-cmp work with the language server's
    --         -- completion results.
    --         'hrsh7th/cmp-nvim-lsp',
    --         -- nvim-cmp needs a snippet engine to work.
    --         'L3MON4D3/LuaSnip',
    --         -- This is the source for nvim-cmp to connect to luasnip
    --         'saadparwaiz1/cmp_luasnip',
    --     },
    --     config = function()
    --         local cmp = require('cmp')
    --         local luasnip = require('luasnip')
    --
    --         cmp.setup {
    --             snippet = {
    --                 expand = function(args)
    --                     luasnip.lsp_expand(args.body)
    --                 end,
    --             },
    --             mapping = cmp.mapping.preset.insert({
    --                 ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    --                 ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    --                 ['<C-Space>'] = cmp.mapping.complete(),
    --                 ['<C-k>'] = cmp.mapping.close(),
    --                 ['<CR>'] = cmp.mapping.confirm {
    --                     behavior = cmp.ConfirmBehavior.Replace,
    --                     select = true,
    --                 },
    --                 ['<Tab>'] = cmp.mapping(function(fallback)
    --                     if cmp.visible() then
    --             cmp.select_next_item()
    --                     elseif luasnip.expand_or_jumpable() then
    --             luasnip.expand_or_jump()
    --                     else
    --             fallback()
    --                     end
    --                 end, { 'i', 's' }),
    --                 ['<S-Tab>'] = cmp.mapping(function(fallback)
    --                     if cmp.visible() then
    --             cmp.select_prev_item()
    --                     elseif luasnip.jumpable(-1) then
    --             luasnip.jump(-1)
    --                     else
    --             fallback()
    --                     end
    --                 end, { 'i', 's' }),
    --             }),
    --             sources = {
    --                 { name = 'nvim_lsp' },
    --                 { name = 'luasnip' },
    --             },
    --         }
    --     end
    -- },

})

