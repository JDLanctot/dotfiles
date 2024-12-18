local Ms = {
	"github/copilot.vim",
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	dependencies = {
		"zbirenbaum/copilot-cmp",
	},
}

function Ms.config()
	require("copilot").setup({
		panel = {
			keymap = {
				jump_next = "<M-j>",
				jump_prev = "<M-k>",
				accept = "<M-l>",
				refresh = "r",
				open = "<M-CR>",
			},
		},
		suggestion = {
			enabled = true,
			auto_trigger = true,
			keymap = {
				accept = "<M-l>",
				next = "<M-j>",
				prev = "<M-k>",
				dismiss = "<M-h>",
			},
		},
		filetypes = {
			markdown = true,
			help = false,
			gitcommit = false,
			gitrebase = false,
			hgcommit = false,
			svn = false,
			cvs = false,
			["."] = false,
		},
		copilot_node_command = "node",
	})

	local opts = { noremap = true, silent = true }
	vim.api.nvim_set_keymap("n", "<c-s>", ":lua require('copilot.suggestion').toggle_auto_trigger()<CR>", opts)

	-- require("copilot_cmp").setup()
end

return Ms
