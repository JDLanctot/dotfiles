local M = {
    'williamboman/mason.nvim',
    dependencies = {
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
}

function M.config()
    require('mason').setup {
        ui = {
            icons = require("toofaeded.icons").for_mason,
            border = "rounded",
        },
    }
    require('mason-lspconfig').setup {
        ensure_installed = require("utils.servers"),
        automatic_enable = false,
    }

    require('mason-tool-installer').setup {
        ensure_installed = require("utils.linters"),
    }
end

return M
