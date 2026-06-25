local M = {
    "theprimeagen/refactoring.nvim",
    dependencies = {
        "lewis6991/async.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
}

function M.config()
    require('refactoring').setup({})

    vim.api.nvim_set_keymap("v", "<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false})
end

return M
