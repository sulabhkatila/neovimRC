function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

local rose = {
	"rose-pine/neovim",
	name = "rose-pine",
	config = function()
		require("rose-pine").setup({
			disable_background = true,
		})

		vim.cmd("colorscheme rose-pine")

		ColorMyPencils()
	end,
}

local tokyonight = {

	"folke/tokyonight.nvim",
	config = function()
		require("tokyonight").setup({
			-- 	-- your configuration comes here
			-- or leave it empty to use the default settings
			style = "moon", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
			transparent = true, -- Enable this to disable setting the background color
			terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
			styles = {
				-- Style to be applied to different syntax groups
				-- Value is any valid attr-list value for `:help nvim_set_hl`
				comments = { italic = true },
				keywords = { italic = false },
				-- Background styles. Can be "dark", "transparent" or "normal"
				sidebars = "dark", -- style for sidebars, see below
				floats = "dark", -- style for floating windows
			},
		})
	end,
	-- 	},

	-- rose,
}

local sonokai = {
	{
		"sainnhe/sonokai",
		lazy = false,
		priority = 999,
		init = function()
			transparent = true
			-- Optionally configure and load the colorscheme
			-- directly inside the plugin declaration.
			vim.g.sonokai_enable_italic = true
			-- vim.g.sonokai_style = "shusia"
			-- vim.g.sonokai_style = "atlantis"
			-- :andromeda
			vim.g.sonokai_style = "shusia"
			vim.cmd.colorscheme("sonokai")
		end,
	},

	-- rose,
}

local pussy_override = {
	-- this 16 colors are changed to onedark
	base = "#282c34",
	mantle = "#353b45",
	surface0 = "#3e4451",
	surface1 = "#545862",
	surface2 = "#565c64",
	text = "#abb2bf",
	rosewater = "#b6bdca",
	lavender = "#c8ccd4",
	red = "#e06c75",
	peach = "#d19a66",
	yellow = "#e5c07b",
	green = "#98c379",
	teal = "#56b6c2",
	blue = "#61afef",
	mauve = "#c678dd",
	flamingo = "#be5046",

	-- now patching extra palettes
	maroon = "#e06c75",
	sky = "#d19a66",

	-- extra colors not decided what to do
	pink = "#F5C2E7",
	sapphire = "#74C7EC",

	subtext1 = "#BAC2DE",
	subtext0 = "#A6ADC8",
	overlay2 = "#9399B2",
	overlay1 = "#7F849C",
	overlay0 = "#6C7086",

	crust = "#11111B",
}

local catppuccin = {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 999,

	config = function()
		require("catppuccin").setup({
			flavour = "auto", -- latte, frappe, macchiato, mocha
			background = { -- :h background
				light = "macchiato",
				dark = "macchiato",
			},
			transparent_background = false, -- disables setting the background color.
			show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
			term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
			dim_inactive = {
				enabled = false, -- dims the background color of inactive window
				shade = "dark",
				percentage = 0.15, -- percentage of the shade to apply to the inactive window
			},
			no_italic = false, -- Force no italic
			no_bold = false, -- Force no bold
			no_underline = false, -- Force no underline
			styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
				comments = { "italic" }, -- Change the style of comments
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
				-- miscs = {}, -- Uncomment to turn off hard-coded styles
			},
			color_overrides = pussy_override,
			custom_highlights = {},
			default_integrations = true,
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				notify = false,
				mini = {
					enabled = true,
					indentscope_color = "",
				},
				-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
			},
		})

		-- setup must be called before loading
		vim.cmd.colorscheme("catppuccin")
	end,
}

local dracula = {
	"Mofiqul/dracula.nvim",
	priority = 999,
	config = function()
		vim.cmd.colorscheme("dracula")
	end,
}

return { sonokai, rose }
--return sonokai
-- return {
-- 	sonokai,
-- 	{
-- 		"rose-pine/neovim",
-- 		name = "rose-pine",
-- 		config = function()
-- 			require("rose-pine").setup({
-- 				disable_background = true,
-- 			})
--
-- 			vim.cmd("colorscheme rose-pine")
--
-- 			ColorMyPencils()
-- 		end,
-- 	},
-- }
