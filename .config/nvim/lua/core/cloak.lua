local M = {
	"laytan/cloak.nvim",
	cmd = "Copilot",
	event = "InsertEnter",
}

function M.config()
	require("copilot").setup({
		panel = {
			enabled = true,
			auto_refresh = false,
			keymap = {
				jump_prev = "[[",
				jump_next = "]]",
				accept = "<CR>",
				refresh = "gr",
				open = "<M-CR>",
			},
			layout = {
				position = "bottom", -- | top | left | right
				ratio = 0.4,
			},
		},
		suggestion = {
			enabled = true,
			auto_trigger = false,
			debounce = 75,
			keymap = {
				accept = "<M-l>",
				accept_word = false,
				accept_line = false,
				next = "<M-]>",
				prev = "<M-[>",
				dismiss = "<C-]>",
			},
		},
		filetypes = {
			yaml = false,
			markdown = false,
			help = false,
			gitcommit = false,
			gitrebase = false,
			hgcommit = false,
			svn = false,
			cvs = false,
			["."] = false,
			sh = function()
				if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
					-- disable for .env files
					return false
				end
				return true
			end,
		},
		copilot_node_command = "node", -- Node.js version must be > 18.x
		server_opts_overrides = {},
	})
end

return M
