local M = {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration

		-- Only one of these is needed.
		"nvim-telescope/telescope.nvim", -- optional
		-- "ibhagwan/fzf-lua",              -- optional
		-- "echasnovski/mini.pick",         -- optional
	},
	cmd = "Neogit",
	keys = {
		{ "<leader>gg", "<cmd>Neogit<CR>", desc = "Neogit" },
	},
	opts = {
		integrations = {
			diffview = true,
			telescope = true,
		},
		disable_signs = false,
		disable_context_highlighting = false,
		disable_commit_confirmation = false,
		auto_refresh = true,
		disable_builtin_notifications = false,
		use_magit_keybindings = false,
		kind = "tab",
		signs = {
			-- { CLOSED, OPENED }
			section = { "", "" },
			item = { "", "" },
			hunk = { "", "" },
		},
		sections = {
			untracked = {
				folded = false,
				hidden = false,
			},
			unstaged = {
				folded = false,
				hidden = false,
			},
			staged = {
				folded = false,
				hidden = false,
			},
			stashes = {
				folded = true,
				hidden = false,
			},
			unpulled = {
				folded = true,
				hidden = false,
			},
			unmerged = {
				folded = false,
				hidden = false,
			},
			recent = {
				folded = true,
				hidden = false,
			},
		},
	},
}

return M
