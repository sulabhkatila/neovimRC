return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP.
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ "j-hui/fidget.nvim", opts = {} },

		-- Allows extra capabilities provided by nvim-cmp
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Jump to the definition of the word under your cursor.
				--  This is where a variable was first declared, or where a function is defined, etc.
				--  To jump back, press <C-t>.
				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

				-- Find references for the word under your cursor.
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

				-- Jump to the implementation of the word under your cursor.
				--  Useful when your language has ways of declaring types without an actual implementation.
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

				-- Jump to the type of the word under your cursor.
				--  Useful when you're not sure what type a variable is and you want to see
				--  the definition of its *type*, not where it was *defined*.
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

				-- Fuzzy find all the symbols in your current document.
				--  Symbols are things like variables, functions, types, etc.
				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

				-- Fuzzy find all the symbols in your current workspace.
				--  Similar to document symbols, except searches over your entire project.
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

				-- Rename the variable under your cursor.
				--  Most Language Servers support renaming across files, etc.
				-- map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("R", vim.lsp.buf.rename, "[R]e[n]ame")

				-- Execute a code action, usually your cursor needs to be on top of an error
				-- or a suggestion from your LSP for this to activate.
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

				-- WARN: This is not Goto Definition, this is Goto Declaration.
				--  For example, in C this would take you to the header.
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				-- Show the hover information for the word under your cursor.
				map("K", vim.lsp.buf.hover, "Show [H]over")

				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				-- The following code creates a keymap to toggle inlay hints in your
				-- code, if the language server you are using supports them
				--
				-- This may be unwanted, since they displace some of your code
				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- LSP servers and clients are able to communicate to each other what features they support.
		--  By default, Neovim doesn't support everything that is in the LSP specification.
		--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
		--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- Enable the following language servers
		--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		--
		--  Add any additional override configuration in the following tables. Available keys are:
		--  - cmd (table): Override the default command used to start the server
		--  - filetypes (table): Override the default list of associated filetypes for the server
		--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
		--  - settings (table): Override the default settings passed when initializing the server.
		--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
		local servers =
			{
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`tsserver`) will work just fine
				-- tsserver = {},
				--
				clangd = {
					cmd = {
						"clangd",
						"--background-index",
						"--offset-encoding=utf-16",
						"--clang-tidy",
						"--header-insertion=iwyu",
					},
					-- Explanation:
					-- --background-index: Indexes the project in the background for better performance.
					-- --clang-tidy: Enables Clang-Tidy for linting and diagnostics.
					-- --header-insertion=never: Prevents automatic insertion of headers (useful for C projects).

					settings = {
						clangd = {
							fallbackFlags = { "-std=c11", "-Wall", "-Wextra", "-Wpedantic" },
							-- Example: Specify default flags for compilation (C11 standard).
						},
					},
					filetypes = { "c", "h" },
					init_options = {
						clangdFileStatus = true, -- Show file status updates in the editor
					},
				},

				lua_ls = {
					-- cmd = {...},
					-- filetypes = { ...},
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
				-- rust_analyzer = {
				-- 	settings = {
				-- 		["rust-analyzer"] = {
				-- 			cargo = {
				-- 				allFeatures = true,
				-- 			},
				-- 			procMacro = {
				-- 				enable = true,
				-- 			},
				-- 			checkOnSave = {
				-- 				command = "clippy",
				-- 			},
				-- 			inlayHints = {
				-- 				enable = true,
				-- 				typeHints = true,
				-- 				chainingHints = true,
				-- 				parameterHints = true,
				-- 				lifetimeElisionHints = {
				-- 					enable = true,
				-- 					useParameterNames = true,
				-- 				},
				-- 			},
				-- 		},
				-- 	},
				-- },

				pyright = {
					settings = {
						pylsp = {
							configurationSources = { "flake8" },
							plugins = {
								pylint = { enabled = true },
								pyflakes = { enabled = false },
								pycodestyle = {
									ignore = { "E501" }, -- Ignore line length warning
									line_length = 88,
								},
								mccabe = { enabled = false },
								yapf = { enabled = false },
								black = {
									enabled = true,
									line_length = 88, -- Use Black's line length
								},
								pyls_isort = { enabled = true },
								pylsp_mypy = { enabled = true, live_mode = false },
							},
						},
					},
				},

				tsserver = {
					settings = {},
					on_attach = function(client, bufnr)
						-- Disable `tsserver`'s formatting if you're using another formatter (like `prettier`)
						client.server_capabilities.documentFormattingProvider = true
						-- Add more custom on_attach settings if needed
					end,
				},

				gopls = {
					gofumpt = true,
					codelenses = {
						gc_details = false,
						generate = true,
						regenerate_cgo = true,
						run_govulncheck = true,
						test = true,
						tidy = true,
						upgrade_dependency = true,
						vendor = true,
					},
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
						returnTypes = true,
					},
					analyses = {
						fieldalignment = true,
						nilness = true,
						unusedparams = true,
						unusedwrite = true,
						useany = true,
					},
					usePlaceholders = true,
					completeUnimported = true,
					staticcheck = true,
					directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
					semanticTokens = true,
				},

				jdtls = {
					cmd = {
						"jdtls",
					},
					settings = {
						java = {
							completion = {
								favoriteStaticMembers = { "org.junit.Assert.*", "org.mockito.Mockito.*" },
								filteredTypes = { "com.sun.*", "java.awt.*" },
							},
							codeGeneration = {
								toString = {
									template = "${object.className}(${member.name}=${member.value})",
								},
							},
						},
					},
					root_dir = require("lspconfig").util.root_pattern(
						".git",
						"mvnw",
						"gradlew",
						"pom.xml",
						"build.gradle"
					),
					filetypes = { "java" },
				},
				omnisharp = {
					cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
					-- Explanation:
					-- --languageserver: Starts Omnisharp in Language Server mode.
					-- --hostPID: Sends the current Neovim process ID for debugging purposes.

					settings = {
						omnisharp = {
							enableRoslynAnalyzers = true, -- Enables Roslyn analyzers for additional code analysis.
							organizeImportsOnFormat = true, -- Automatically organize imports when formatting.
							enableEditorConfigSupport = true, -- Support `.editorconfig` files.
						},
					},
					filetypes = { "cs", "vb" }, -- C# and Visual Basic file types.
					init_options = {
						FormattingOptions = {
							IndentSize = 4,
							TabSize = 4,
							InsertSpaces = true,
						},
					},
				},
			},
			-- Ensure the servers and tools above are installed
			--  To check the current status of installed tools and/or manually install
			--  other tools, you can run
			--    :Mason
			--
			--  You can press `g?` for help in this menu.
			require("mason").setup()

		-- You can add other tools here that you want Mason to install
		-- for you, so that they are available from within Neovim.
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for tsserver)
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,

				rust_analyzer = function() end,
				-- pyright = function() end,

				-- gopls = function() end,
			},
		})
	end,
}
