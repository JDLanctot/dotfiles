require("toofaeded.remap")
require("toofaeded.set")
require("toofaeded.launch")

-- Spec the core plugins individually so we can choose to disable them
spec("core.noconfig")
spec("core.cloak")
spec("core.cmp")
spec("core.colors")
spec("core.comment")
spec("core.cursor")
spec("core.devicons")
spec("core.fidget")
spec("core.fugitive")
spec("core.harpoon")
spec("core.lint")
spec("core.lsp")
spec("core.lualine")
spec("core.mason")
spec("core.none-ls")
spec("core.nvim-tree")
spec("core.refactoring")
spec("core.telescope")
spec("core.toggleterm")
spec("core.treesitter")
spec("core.trouble")
spec("core.undotree")

-- Spec the core plugins individually so we can choose to disable them
spec("extras.breadcrumbs")
spec("extras.copilot")
-- spec("extras.dashboard")
-- spec("extras.flash")
-- spec("extras.tabby")
-- spec("extras.schemastore")
-- spec("extras.zenmode")

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
