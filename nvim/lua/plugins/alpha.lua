return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		-- local alpha = require("alpha")
		-- local dashboard = require("alpha.themes.startify")
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = {
			[[                                                                       ]],
			[[                                                                       ]],
			[[                                                                       ]],
			[[                                                                       ]],
			[[                                                                     ]],
			[[       ████ ██████           █████      ██                     ]],
			[[      ███████████             █████                             ]],
			[[      █████████ ███████████████████ ███   ███████████   ]],
			[[     █████████  ███    █████████████ █████ ██████████████   ]],
			[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
			[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
			[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
			[[                                                                       ]],
			[[                                                                       ]],
			[[                                                                       ]],
		}

		-- Set menu
		-- dashboard.section.buttons.val = {
		-- 	dashboard.button( "e", "  > New file" , ":ene <BAR> startinsert <CR>"),
		-- 	dashboard.button( "f", "􀡢  > Find file", ":cd $HOME/Develeper | Telescope find_files<CR>"),
		-- 	dashboard.button( "r", "  > Recent"   , ":Telescope oldfiles<CR>"),
		-- 	dashboard.button( "s", "  > Settings" , ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
		-- 	dashboard.button( "q", "􁉄  > Quit NVIM", ":qa<CR>"),
		-- }

		dashboard.section.buttons.val = {
			dashboard.button("n", " > New File", "<cmd>ene<CR>"),
			dashboard.button("f", "󰱼 > Find File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("r", " > Find Recent Files", "<cmd>Telescope oldfiles<CR>"),
			dashboard.button("c", " > Configuration", "<cmd>edit ~/.config/nvim/init.lua<CR>"),
			dashboard.button("q", " > Quit NVIM", "<cmd>qa<CR>"),
		}

		-- Give the returned couplet to alpha's footer
		-- dashboard.section.footer.val = ashaar()

		alpha.setup(dashboard.opts)
	end,
}
