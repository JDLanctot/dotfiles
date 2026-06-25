local G = {
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" },
			{ "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "DiffView" },
		},
	},
}

return G
