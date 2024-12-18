require("toofaeded.remap")
require("toofaeded.set")
require("toofaeded.launch")

-- Spec the core plugins individually so we can choose to disable them
spec("core.completion.copilot")
spec("core.completion.cmp")

spec("core.errors.trouble")

spec("core.func.matchup")
spec("core.func.middleclass")
spec("core.func.multiline")
spec("core.func.refactoring")
spec("core.func.rename")
spec("core.func.undotree")

spec("core.git.diffview")
-- spec("core.git.fugitive")
spec("core.git.gitsigns")
spec("core.git.neogit")

spec("core.install.mason")

-- spec("core.lsp.fidget")
spec("core.lsp.lint")
spec("core.lsp.lsp")
spec("core.lsp.none-ls")

spec("core.navigation.harpoon")
spec("core.navigation.leap")
spec("core.navigation.nvim-navic")
spec("core.navigation.nvim-tree")
spec("core.navigation.telescope")

spec("core.syntax.comment")
spec("core.syntax.treesitter")

spec("core.terminal.toggleterm")

spec("core.ui.cloak")
spec("core.ui.colors")
-- spec("core.ui.cursor")
spec("core.ui.devicons")
spec("core.ui.dressing")
spec("core.ui.illuminate")
spec("core.ui.indentscope")
spec("core.ui.lualine")
spec("core.ui.scrollbar")
spec("core.ui.notify")
spec("core.ui.pairs")
spec("core.ui.whichkey")
spec("core.ui.windows")

-- Spec the core plugins individually so we can choose to disable them
spec("extras.breadcrumbs")
-- spec("extras.dashboard")
-- spec("extras.flash")
-- spec("extras.tabby")
-- spec("extras.schemastore")
-- spec("extras.zenmode")

-- Require the lazy after so it setups the spec'd plugins
require("core.install.lazy")

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
        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
