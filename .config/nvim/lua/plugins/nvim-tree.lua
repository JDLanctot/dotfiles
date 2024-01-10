return {
    -- File folder browser (only on toggle not default browsing)
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local api = require 'nvim-tree.api'

            vim.keymap.set('n', '<c-g>', api.tree.toggle)

            local function my_on_attach(bufnr)
                local function opts(desc)
                    return {
                        desc = 'nvim-tree: ' .. desc,
                        buffer = bufnr,
                        noremap = true,
                        silent = true,
                        nowait = true,
                    }
                end

                -- default mappings
                api.config.mappings.default_on_attach(bufnr)

                -- custom mappings
                vim.keymap.set('n', '<c-g>', api.tree.toggle, opts 'Toggle')
                vim.keymap.set('n', '?', api.tree.toggle_help, opts 'Help')
            end

            require('nvim-tree').setup {
                disable_netrw = false,
                hijack_netrw = false, -- Collapsible navigator is gross for main nav
            }
        end,
    },
}
