local M = {}

M.servers = {
	"lua_ls",
	"rust_analyzer",
	"vtsls", -- tsserver",
	"tailwindcss",
	"jsonls",
	"pyright",
	"julials",
}

M.linters = {
	"stylua",
	"eslint_d",
	"prettierd",
	"biome",
	-- "flake8",
}

return M
