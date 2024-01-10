return {
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup({
                padding = true,
                sticky = true,
                ignore = nil,
                toggler = {
                    line = 'gcc',
                    block = 'gbc',
                },
                opleader = {
                    line = 'gc',
                    block = 'gb',
                },
                extra = {
                    above = 'gcO',
                    below = 'gco',
                    eol = 'gcA',
                },
                mappings = {
                    basic = true,
                    extra = true,
                },
                pre_hook = nil,
                post_hook = nil,
            })
        end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            vim.keymap.set('n', ']z', function()
                require('todo-comments').jump_next()
            end, { desc = 'Next todo comment' })

            vim.keymap.set('n', '[z', function()
                require('todo-comments').jump_prev()
            end, { desc = 'Previous todo comment' })

            vim.keymap.set(
                'n',
                '<leader>z',
                '<cmd>TodoTelescope<cr>',
                { desc = 'Previous todo comment' }
            )

            require('todo-comments').setup()
        end,
    },
}
