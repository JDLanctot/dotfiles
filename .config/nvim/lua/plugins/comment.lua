local C  = {
    "numToStr/Comment.nvim",
}

function C.config()
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
end

local T = {
    "folke/todo-comments.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
}

function T.config()
    vim.keymap.set('n', ']z', function()
        require('todo-comments').jump_next()
    end, { desc = 'next todo comment' })

    vim.keymap.set('n', '[z', function()
        require('todo-comments').jump_prev()
    end, { desc = 'previous todo comment' })

    vim.keymap.set(
        'n',
        '<leader>z',
        '<cmd>todotelescope<cr>',
        { desc = 'previous todo comment' }
    )

    require('todo-comments').setup()
end

return {C, T}
