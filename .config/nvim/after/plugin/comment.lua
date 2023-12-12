-- require("Comment").setup()

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
