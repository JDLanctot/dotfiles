require("toofaeded.remap")
require("toofaeded.set")
require("toofaeded.launch")

-- Spec the plugins individually so we can choose to disable them
spec("plugins.noconfig")
spec("plugins.cloak")
spec("plugins.cmp")
spec("plugins.colors")
spec("plugins.comment")
spec("plugins.cursor")
spec("plugins.dashboard")
spec("plugins.devicons")
spec("plugins.flash")
spec("plugins.fugitive")
spec("plugins.harpoon")
spec("plugins.lint")
spec("plugins.lsp")
spec("plugins.lualine")
spec("plugins.mason")
spec("plugins.nvim-tree")
spec("plugins.refactoring")
spec("plugins.telescope")
spec("plugins.treesitter")
spec("plugins.trouble")
spec("plugins.undotree")
spec("plugins.zenmode")

-- Require the lazy after so it setups the spec'd plugins
require("toofaeded.lazy")

local augroup = vim.api.nvim_create_augroup
local TooFaededGroup = augroup('TooFaeded', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = TooFaededGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd('LspAttach', {
    group = TooFaededGroup,
    callback = function(e)
        local opts = { buffer = e.buf }

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
