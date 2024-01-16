local M = {
    "neovim/nvim-lspconfig",
    dependencies = {
        'j-hui/fidget.nvim',
    },
}

function M.config()
    local lspconfig = require('lspconfig')

    -- lua
    lspconfig.lua_ls.setup({
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' },
                },
            },
        },
    })

    -- Python
    lspconfig.pyright.setup({})

    -- Julia
    lspconfig.julials.setup({})

    require('fidget').setup({})
    require('fidget').setup({})

    vim.diagnostic.config({
        virtual_text = true,
        update_in_insert = true,
        float = {
            focusable = true,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },

    })
end

return M
