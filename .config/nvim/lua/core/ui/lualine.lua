local M = {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"AndreM222/copilot-lualine",
	},
}

function M.config()
	local colors = {
		red = "#ca1243",
		grey = "#a0a1a7",
		black = "#383a42",
		white = "#f3f3f3",
		light_green = "#83a598",
		orange = "#fe8019",
		green = "#8ec07c",
	}

	local icons = require("toofaeded.icons")

	local function modified()
		if vim.bo.modified then
			return "+"
		elseif vim.bo.modifiable == false or vim.bo.readonly == true then
			return "-"
		end
		return ""
	end

	require("lualine").setup({
		icons_enabled = true,
		options = {
			ignore_focus = { "NvimTree" },
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = {
				{
					"filename",
					path = 3,
				},
			},
			lualine_c = {
				{
					"diagnostics",
					sources = { "nvim_diagnostic" },
					sections = { "error", "warn", "info", "hint" },
					diagnostics_color = {
						error = { fg = colors.red },
						warn = { fg = colors.orange },
						info = { fg = colors.white },
						hing = { fg = colors.blue },
					},
					symbols = icons.lualine_diagnostics,
					colored = true,
					update_in_insert = false,
				},
			},
			lualine_x = {
				{
					"copilot",
					-- Default values
					symbols = {
						status = {
							icons = {
								enabled = " ",
								sleep = " ", -- auto-trigger disabled
								disabled = " ",
								warning = " ",
								unknown = " ",
							},
							hl = {
								enabled = "#50FA7B",
								sleep = "#AEB7D0",
								disabled = "#6272A4",
								warning = "#FFB86C",
								unknown = "#FF5555",
							},
						},
						spinners = require("copilot-lualine.spinners").dots,
						spinner_color = "#6272A4",
					},
					show_colors = false,
					show_loading = true,
				},
			},
			lualine_y = {
				"branch",
				{
					"diff",
					symbols = icons.lualine_git,
					diff_color = {
						added = { fg = colors.green },
						modified = { fg = colors.orange },
						removed = { fg = colors.red },
					},
				},
			},
			lualine_z = { "filetype" },
		},
		extensions = { "quickfix", "man", "fugitive" },
	})
end

return M
