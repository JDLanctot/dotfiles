-- bigfile.lua - Disable heavy features for large files
local M = {}

local function disable_features()
	-- Disable syntax highlighting
	vim.cmd("syntax off")

	-- Disable treesitter
	local ok, ts = pcall(require, "nvim-treesitter.configs")
	if ok then
		vim.cmd("TSBufDisable highlight")
		vim.cmd("TSBufDisable indent")
		vim.cmd("TSBufDisable incremental_selection")
	end

	-- Disable LSP
	vim.cmd("LspStop")

	-- Disable illuminate
	local illuminate_ok, illuminate = pcall(require, "illuminate")
	if illuminate_ok then
		illuminate.pause_buf()
	end

	-- Disable indent guides
	local mini_ok = pcall(require, "mini.indentscope")
	if mini_ok then
		vim.b.miniindentscope_disable = true
	end

	-- Disable gitsigns
	local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
	if gitsigns_ok then
		gitsigns.detach()
	end

	-- Set basic options for performance
	vim.opt_local.spell = false
	vim.opt_local.swapfile = false
	vim.opt_local.undofile = false
	vim.opt_local.breakindent = false
	vim.opt_local.colorcolumn = ""
	vim.opt_local.statuscolumn = ""
	vim.opt_local.signcolumn = "no"
	vim.opt_local.foldcolumn = "0"
	vim.opt_local.winbar = ""

	-- Notify user
	vim.notify("Big file detected. Disabled heavy features for better performance.", vim.log.levels.WARN)
end

local function setup_bigfile_detection()
	vim.api.nvim_create_autocmd("BufReadPre", {
		callback = function()
			local file = vim.fn.expand("<afile>")
			if vim.fn.getfsize(file) > 1024 * 1024 then -- 1MB threshold
				disable_features()
			end
		end,
	})
end

-- Call setup
setup_bigfile_detection()

return M
