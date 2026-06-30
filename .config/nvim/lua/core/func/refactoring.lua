local M = {
    "theprimeagen/refactoring.nvim",
}

function M.config()
    require('refactoring').setup({})

    vim.api.nvim_set_keymap("v", "<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false})
end

return M
