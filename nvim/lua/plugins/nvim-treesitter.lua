return {
	"nvim-treesitter/nvim-treesitter",
	name = "nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			--   ensure_installed = {
			--     "c",
			--     "lua",
			--     "vim",
			--     "vimdoc",
			--     "query",
			--     "python",
			--     "javascript",
			--     "html",
			--     "css",
			--     "json",
			--     "csv",
			--   },
			auto_install = true,
			sync_install = false,
			highlight = {
				enable = true,
			},
		})
	end,
}
