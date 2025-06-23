local T = {
	-- Telescoping
	"nvim-telescope/telescope.nvim",
	-- tag = "0.1.5",
	dependencies = { "nvim-lua/plenary.nvim" },
}

function T.config()
	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
	vim.keymap.set("n", "<C-p>", builtin.git_files, {})
	vim.keymap.set("n", "<leader>pws", function()
		local word = vim.fn.expand("<cword>")
		builtin.grep_string({ search = word })
	end)
	vim.keymap.set("n", "<leader>pWs", function()
		local word = vim.fn.expand("<cWORD>")
		builtin.grep_string({ search = word })
	end)
	vim.keymap.set("n", "<leader>ps", function()
		builtin.grep_string({ search = vim.fn.input("Grep > ") })
	end)
	vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
	vim.keymap.set("n", "<leader>pb", builtin.buffers, {})
	vim.keymap.set("n", "<leader>pd", "<CMD>Telescope neovim-project discover<CR>")
	vim.keymap.set("n", "<leader>ph", "<CMD>Telescope neovim-project history<CR>")
	vim.keymap.set("n", "<leader>n", function()
		require("telescope").extensions.notify.notify()
	end, { desc = "Notification History" })
end

local directories = require("utils.directories")

local C = {
	-- Telescope Project Directories
	"coffebar/neovim-project",
	opts = {
		projects = directories,
		-- Disable auto session loading for dashboard compatibility
		session_manager_opts = {
			autosave_ignore_dirs = {
				vim.fn.expand("~"), -- Don't auto-restore when opening home directory
			},
			autosave_ignore_filetypes = {
				"alpha",
				"dashboard",
			},
		},
		-- Only load last session if explicitly opening a project, not for general usage
		last_session_on_startup = false,
	},
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope.nvim", tag = "0.1.5" },
		{ "Shatur/neovim-session-manager" },
	},
	lazy = false,
	priority = 100,
}

function C.init()
	-- enable saving the state of plugins in the session
	vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
end

return { T, C }
