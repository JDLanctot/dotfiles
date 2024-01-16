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
            icons = {
                package_installed = '✓',
                package_pending = '➜',
                package_uninstalled = '✗',
            },
        },
    }

    require('mason-lspconfig').setup {}
    require('mason-tool-installer').setup {
        ensure_installed = {
            'lua-language-server',
            'stylua',
            'eslint_d',
            'prettierd',
            'rust-analyzer',
            'tsserver',
            'tailwindcss',
            'pyright',
            'julials'
        },
    }
end

return M
