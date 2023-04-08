-- Maps
vim.g.mapleader = ' '
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set('t', 'jk', '<C-\\><C-n>', { desc = 'exit terminal insert mode' })

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Tabs
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Case-insensitive search, unless search includes capital letter
vim.o.ignorecase = true
vim.o.smartcase = true

-- Minimum # lines to show around cursor when scrolling around
vim.opt.scrolloff = 4

-- Don't remember why this is set. Something to do about speeding up certain actions.
vim.opt.updatetime = 100

-- Don't wrap lines
vim.opt.wrap = false

vim.api.nvim_create_autocmd(
	'BufEnter',
	{ pattern = { "*.md" },
	callback = function()
		vim.opt.wrap = true
		vim.opt.linebreak = true
	end
})

return {
	packer_spec = function(use)
		use('tpope/vim-fugitive')
		use('tpope/vim-surround')
		use('tpope/vim-repeat')
		use({
			'nvim-lualine/lualine.nvim',
			config = function()
				require('lualine').setup()
			end
		})
		use({
			"preservim/nerdtree",
			config = function()
				vim.g.NERDTreeWinSize = 50
			end
		})
		use({
			'navarasu/onedark.nvim',
			config = function()
				require('onedark').load()
			end
		})
		use({
			'airblade/vim-gitgutter',
			config = function()
				-- Make sign column always show, otherwise it pops in when the first git-tracked edit has been made
				vim.opt.signcolumn = 'yes'
			end
		})
		use({
			'nvim-telescope/telescope.nvim',
			tag = '0.1.1',
			requires = {
				{'nvim-lua/plenary.nvim'},
				{
					-- Not really required, but I skip the opt = true so that this gets installed
					'kyazdani42/nvim-web-devicons'
				}
			},
			config = function()
				require('telescope').setup({
					defaults = {
						mappings = {
							-- I don't remember the reason for this.
							i = {
								['<C-u>'] = false,
								['<C-d>'] = false,
							},
						},
					}
				})
				local telescope_builtin = require('telescope.builtin')
				vim.keymap.set('n', '<leader>sk', telescope_builtin.keymaps, { desc = '[S]earch [K]eymaps' })
				vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, { desc = '[S]earch [H]elp' })
				vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, { desc = '[S]earch [F]iles' })
				vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, { desc = '[S]earch by [G]rep' })
				vim.keymap.set('n', '<leader>sw', telescope_builtin.grep_string, { desc = '[S]earch current [W]ord' })
				vim.keymap.set('n', '<leader>?',  telescope_builtin.oldfiles, { desc = '[?] Find recently opened files' })
				vim.keymap.set('n', '<leader><space>', telescope_builtin.buffers, { desc = '[ ] Find existing buffers' })
				vim.keymap.set('n', '<leader>/',  telescope_builtin.current_buffer_fuzzy_find, { desc = '[/] Fuzzily search in current buffer]' })
				vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
			end
		})
		use({
			'nvim-treesitter/nvim-treesitter',
			run = ':TSUpdate',
			config = function()
				require('nvim-treesitter.configs').setup({
					-- Disabled for now, I want to be able to see the effects before and after
					highlight = {
						enable = true,
						-- I don't know why this was disabled. I think because I thought the non-treesitter one was better
						-- disable = { 'markdown' }
					},
					context_commentstring = {
						enable = true,
						enable_autocmd = false,
					},
				})
			end
		})
		use({
			'numToStr/Comment.nvim',
			requires = {'JoosepAlviste/nvim-ts-context-commentstring'},
			config = function()
				require('Comment').setup({
					pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
				})
			end
		})
		use({
			"ThePrimeagen/harpoon",
			requires = { 'nvim-lua/plenary.nvim' },
			config = function()
				 vim.keymap.set('n', '<leader>hm', function() require("harpoon.ui").toggle_quick_menu() end, { desc = '[h]arpoon [m]enu', silent = true })
				 vim.keymap.set('n', '<leader>m', function() require("harpoon.mark").add_file() end, { desc = 'harpoon [m]ark', silent = true })
				 vim.keymap.set('n', '<leader>j', function() require("harpoon.ui").nav_file(1) end, { desc = 'harpoon 1st file ([j],k,l,;)', silent = true })
				 vim.keymap.set('n', '<leader>k', function() require("harpoon.ui").nav_file(2) end, { desc = 'harpoon 2nd file (j,[k],l,;)', silent = true })
				 vim.keymap.set('n', '<leader>l', function() require("harpoon.ui").nav_file(3) end, { desc = 'harpoon 3rd file (j,k,[l],;)', silent = true })
				 vim.keymap.set('n', '<leader>;', function() require("harpoon.ui").nav_file(4) end, { desc = 'harpoon 3rd file (j,k,l,[;])', silent = true })
			end
		})
		use({
			"folke/trouble.nvim",
			config = function()
				require('trouble').setup()
			end
		})
	end
}

-- Everything below this line is my old config.
-- #############################################################################

-- Plugins
-- require('packer').startup(function(use)
-- 	use 'wbthomason/packer.nvim'
-- 	use 'neovim/nvim-lspconfig'
-- 	use 'hrsh7th/nvim-cmp'
-- 	use 'hrsh7th/cmp-nvim-lsp'
-- 	use 'hrsh7th/cmp-buffer'
-- 	use 'hrsh7th/cmp-path'
-- 	use 'hrsh7th/cmp-cmdline'
-- 	use 'hrsh7th/cmp-nvim-lsp-signature-help'
-- 	use({ "L3MON4D3/LuaSnip", tag = "v1.*" })
-- 	use 'j-hui/fidget.nvim'
-- 	use 'tpope/vim-sleuth'
-- 	use 'williamboman/mason.nvim'
-- 	use 'williamboman/mason-lspconfig.nvim'
-- 	use 'vim-test/vim-test'
-- 	use "tpope/vim-abolish"
-- 	use "preservim/nerdtree"
-- end)
--
-- require "fidget".setup()
--
-- require("trouble").setup()
--
-- -- Setup completion plugin
-- -- Along with cmp mappings, supports using tab to jump in a snippet.
-- -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
-- local has_words_before = function()
--   unpack = unpack or table.unpack
--   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
-- end
-- local cmp = require('cmp')
-- local luasnip = require("luasnip")
-- cmp.setup({
-- 	mapping = cmp.mapping.preset.insert({
-- 		['<C-Space>'] = cmp.mapping.complete(),
-- 		['<C-e>'] = cmp.mapping.abort(),
-- 		['<CR>'] = cmp.mapping.confirm({ select = true }),
-- 		['<C-f>'] = cmp.mapping.scroll_docs(4),
-- 		['<C-b>'] = cmp.mapping.scroll_docs(-4),
-- 		 ["<Tab>"] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item()
--       elseif luasnip.expand_or_jumpable() then
--         luasnip.expand_or_jump()
--       elseif has_words_before() then
--         cmp.complete()
--       else
--         fallback()
--       end
--     end, { "i", "s" }),
--     ["<S-Tab>"] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_prev_item()
--       elseif luasnip.jumpable(-1) then
--         luasnip.jump(-1)
--       else
--         fallback()
--       end
--     end, { "i", "s" }),
-- 	}),
-- 	sources = cmp.config.sources({
-- 		{ name = 'nvim_lsp', group_index = 1 },
-- 		{ name = 'luasnip', group_index = 1 },
-- 		{ name = 'buffer', group_index = 2 },
-- 		{ name = 'nvim_lsp_signature_help' }
-- 	}),
-- 	snippet = {
-- 		expand = function(args)
-- 			require('luasnip').lsp_expand(args.body)
-- 		end,
-- 	},
-- })
-- local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
-- 
-- -- Setup lsp configs
-- local on_buffer_attach_to_lsp_client = function(_, buffer_number)
-- 	local nmap = function(keys, func, desc)
-- 		vim.keymap.set('n', keys, func, { buffer = buffer_number, desc = desc })
-- 	end
-- 	nmap('gd', vim.lsp.buf.definition, '[G]oto [d]efinition')
-- 	nmap('<leader>D', vim.lsp.buf.type_definition, 'goto type [D]efinition')
-- 	nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
-- 	nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
-- 	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
-- 	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
-- 	nmap('<leader>sd', require('telescope.builtin').lsp_document_symbols, '[S]ymbols in [D]ocument')
-- 	nmap('<leader>sw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]ymbols in [W]orkspace')
-- 	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
-- 	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
-- 	nmap(']d', vim.diagnostic.goto_next, 'Go to next [d]iagnostic')
-- 	nmap('[d', vim.diagnostic.goto_prev, 'Go to prev [d]iagnostic')
-- 	vim.api.nvim_buf_create_user_command(buffer_number, 'Format', function()
-- 		local eslint_client = vim.lsp.get_active_clients({ bufnr = buffer_number, name = 'eslint' })[1]
-- 		if eslint_client then
-- 			vim.cmd('EslintFixAll')
-- 		else
-- 			vim.lsp.buf.format()
-- 		end
-- 	end, { desc = 'Format current buffer with LSP' })
-- 	local format_on_save_group = vim.api.nvim_create_augroup('Format on save', {})
-- 	vim.api.nvim_clear_autocmds({ buffer = buffer_number, group = format_on_save_group })
-- 	vim.api.nvim_create_autocmd('BufWritePre', { buffer = buffer_number, group = format_on_save_group, command = 'Format' })
-- end
-- local server_settings = {
-- 	sumneko_lua = {
-- 		Lua = {
-- 			diagnostics = {
-- 				globals = { 'vim' }
-- 			},
-- 			workspace = {
-- 				library = vim.api.nvim_get_runtime_file("", true),
-- 				checkThirdParty = false,
-- 			},
-- 		}
-- 	},
-- 	rust_analyzer = {
-- 		imports = {
-- 			granularity = {
-- 				group = "module",
-- 			},
-- 			prefix = "self",
-- 		},
-- 		cargo = {
-- 			buildScripts = {
-- 				enable = true,
-- 			},
-- 		},
-- 		procMacro = {
-- 			enable = true
-- 		},
-- 	},
-- 	omnisharp_mono = {}
-- }
-- require('mason').setup()
-- local mason_lspconfig = require('mason-lspconfig')
-- mason_lspconfig.setup()
-- mason_lspconfig.setup_handlers {
-- 	function(server_name)
-- 		require('lspconfig')[server_name].setup {
-- 			capabilities = cmp_capabilities,
-- 			on_attach = on_buffer_attach_to_lsp_client,
-- 			settings = server_settings[server_name],
-- 		}
-- 	end,
-- }
-- 
-- pcall(telescope.load_extension, 'fzf')
-- pcall(telescope.load_extension, "file_browser")
-- 
-- -- vim-test config
-- vim.g['test#strategy'] = 'neovim'
-- vim.g['test#neovim#start_normal'] = 1
-- vim.keymap.set('n', '<leader>tn', ':TestNearest<CR>', { desc = '[t]est [n]earest test', silent = true })
-- vim.keymap.set('n', '<leader>tf', ':TestFile<CR>', { desc = '[t]est [f]ile', silent = true })
-- vim.keymap.set('n', '<leader>tl', ':TestLast<CR>', { desc = '[t]est [l]ast test', silent = true })
-- vim.keymap.set('n', '<leader>tv', ':TestVisit<CR>', { desc = 'go [t]est file last [v]isited', silent = true })

-- -- For the Nand to Tetris course. They provide hdl files, but use a different
-- -- syntax that doesn't exactly match vim's normal hdl syntax highlighting. So I
-- -- just decided to turn it off instead of having things be highlighted weird.
-- vim.api.nvim_create_autocmd('BufEnter', { pattern = { "*.hdl" }, command = 'set filetype=' })
