local tokyonight = {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {},

	init = function()
		-- Optionally configure and load the colorscheme
		-- directly inside the plugin declaration.
		vim.cmd.colorscheme('tokyonight-storm')
	end
}

local sonokai = {
	'sainnhe/sonokai',
	lazy = false,
	priority = 1000,
	init = function()
		-- Optionally configure and load the colorscheme
		-- directly inside the plugin declaration.
		vim.g.sonokai_enable_italic = true
		vim.g.sonokai_style = 'shusia'
		vim.cmd.colorscheme('sonokai')
	end
}

return sonokai
