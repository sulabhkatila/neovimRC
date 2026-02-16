return {
	"windwp/nvim-ts-autotag",
	ft = { "html", "tsx", "jsx" },
	config = function()
		require("nvim-ts-autotag").setup({
			filetypes = { "html", "xml", "tsx", "jsx" }, -- Include additional file types if needed
		})
	end,
}
