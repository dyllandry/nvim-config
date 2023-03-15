vim.keymap.set('i', 'jk', '<Esc>', { desc = 'exit insert mode' })
vim.keymap.set('t', 'jk', '<C-\\><C-n>', { desc = 'exit terminal insert mode' })
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 100
vim.opt.ignorecase = true
vim.g.mapleader = ' '
vim.g.NERDTreeWinSize = 50
vim.opt.conceallevel = 2

-- Plugins
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'neovim/nvim-lspconfig'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/cmp-nvim-lsp-signature-help'
	use({ "L3MON4D3/LuaSnip", tag = "v1.*" })
	use 'NLKNguyen/papercolor-theme'
	use 'navarasu/onedark.nvim'
	use 'morhetz/gruvbox'
	use { 'nvim-lualine/lualine.nvim' }
	use 'j-hui/fidget.nvim'
	use 'tpope/vim-surround'
	use 'tpope/vim-repeat'
	use 'tpope/vim-fugitive'
	use 'tpope/vim-sleuth'
	use 'airblade/vim-gitgutter'
	use { 'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = { 'nvim-lua/plenary.nvim' } }
	use { "nvim-telescope/telescope-file-browser.nvim" }
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	use 'williamboman/mason.nvim'
	use 'williamboman/mason-lspconfig.nvim'
	use 'numToStr/Comment.nvim'
	use 'JoosepAlviste/nvim-ts-context-commentstring'
	use 'vim-test/vim-test'
	use "kyazdani42/nvim-web-devicons"
	use "folke/trouble.nvim"
	use "tpope/vim-abolish"
	use "preservim/nerdtree"
	use { "ThePrimeagen/harpoon", requires = { 'nvim-lua/plenary.nvim' } }
	use { "preservim/vim-markdown", requires = { 'godlygeek/tabular' } }
end)
require "fidget".setup()
require('Comment').setup({
	pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})
require("trouble").setup()

-- Color scheme
require('onedark').load()
-- vim.opt.background = 'light'
-- vim.cmd('colorscheme gruvbox')
-- vim.opt.termguicolors = true

-- Setup completion plugin
-- Along with cmp mappings, supports using tab to jump in a snippet.
-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local cmp = require('cmp')
local luasnip = require("luasnip")
cmp.setup({
	mapping = cmp.mapping.preset.insert({
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		 ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp', group_index = 1 },
		{ name = 'luasnip', group_index = 1 },
		{ name = 'buffer', group_index = 2 },
		{ name = 'nvim_lsp_signature_help' }
	}),
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
})
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Setup lsp configs
local on_buffer_attach_to_lsp_client = function(_, buffer_number)
	local nmap = function(keys, func, desc)
		vim.keymap.set('n', keys, func, { buffer = buffer_number, desc = desc })
	end
	nmap('gd', vim.lsp.buf.definition, '[G]oto [d]efinition')
	nmap('<leader>D', vim.lsp.buf.type_definition, 'goto type [D]efinition')
	nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
	nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
	nmap('<leader>sd', require('telescope.builtin').lsp_document_symbols, '[S]ymbols in [D]ocument')
	nmap('<leader>sw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]ymbols in [W]orkspace')
	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
	nmap(']d', vim.diagnostic.goto_next, 'Go to next [d]iagnostic')
	nmap('[d', vim.diagnostic.goto_prev, 'Go to prev [d]iagnostic')
	vim.api.nvim_buf_create_user_command(buffer_number, 'Format', function()
		local eslint_client = vim.lsp.get_active_clients({ bufnr = buffer_number, name = 'eslint' })[1]
		if eslint_client then
			vim.cmd('EslintFixAll')
		else
			vim.lsp.buf.format()
		end
	end, { desc = 'Format current buffer with LSP' })
	local format_on_save_group = vim.api.nvim_create_augroup('Format on save', {})
	vim.api.nvim_clear_autocmds({ buffer = buffer_number, group = format_on_save_group })
	vim.api.nvim_create_autocmd('BufWritePre', { buffer = buffer_number, group = format_on_save_group, command = 'Format' })
end
local server_settings = {
	sumneko_lua = {
		Lua = {
			diagnostics = {
				globals = { 'vim' }
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
		}
	},
	rust_analyzer = {
		imports = {
			granularity = {
				group = "module",
			},
			prefix = "self",
		},
		cargo = {
			buildScripts = {
				enable = true,
			},
		},
		procMacro = {
			enable = true
		},
	},
	omnisharp_mono = {}
}
require('mason').setup()
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup()
mason_lspconfig.setup_handlers {
	function(server_name)
		require('lspconfig')[server_name].setup {
			capabilities = cmp_capabilities,
			on_attach = on_buffer_attach_to_lsp_client,
			settings = server_settings[server_name],
		}
	end,
}

require('lualine').setup {
	options = {
		theme = 'auto',
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		}
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { 'filename' },
		lualine_x = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { 'filename' },
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
}

require('nvim-treesitter.configs').setup({
	auto_install = true,
	highlight = {
		enable = true,
		disable = { 'markdown' }
	},
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
})

local telescope = require('telescope')
telescope.setup {
	defaults = {
		mappings = {
			i = {
				['<C-u>'] = false,
				['<C-d>'] = false,
			},
		},
	},
}
pcall(telescope.load_extension, 'fzf')
pcall(telescope.load_extension, "file_browser")
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sk', telescope_builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sw', telescope_builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>?', telescope_builtin.oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', telescope_builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', telescope_builtin.current_buffer_fuzzy_find,
	{ desc = '[/] Fuzzily search in current buffer]' })
vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

-- vim-test config
vim.g['test#strategy'] = 'neovim'
vim.g['test#neovim#start_normal'] = 1
vim.keymap.set('n', '<leader>tn', ':TestNearest<CR>', { desc = '[t]est [n]earest test', silent = true })
vim.keymap.set('n', '<leader>tf', ':TestFile<CR>', { desc = '[t]est [f]ile', silent = true })
vim.keymap.set('n', '<leader>tl', ':TestLast<CR>', { desc = '[t]est [l]ast test', silent = true })
vim.keymap.set('n', '<leader>tv', ':TestVisit<CR>', { desc = 'go [t]est file last [v]isited', silent = true })

-- Harpoon config
vim.keymap.set('n', '<leader>hm', function() require("harpoon.ui").toggle_quick_menu() end,
	{ desc = '[h]arpoon [m]enu', silent = true })
vim.keymap.set('n', '<leader>m', function() require("harpoon.mark").add_file() end,
	{ desc = 'harpoon [m]ark', silent = true })
vim.keymap.set('n', '<leader>j', function() require("harpoon.ui").nav_file(1) end,
	{ desc = 'harpoon 1st file ([j],k,l,;)', silent = true })
vim.keymap.set('n', '<leader>k', function() require("harpoon.ui").nav_file(2) end,
	{ desc = 'harpoon 2nd file (j,[k],l,;)', silent = true })
vim.keymap.set('n', '<leader>l', function() require("harpoon.ui").nav_file(3) end,
	{ desc = 'harpoon 3rd file (j,k,[l],;)', silent = true })
vim.keymap.set('n', '<leader>;', function() require("harpoon.ui").nav_file(4) end,
	{ desc = 'harpoon 3rd file (j,k,l,[;])', silent = true })
