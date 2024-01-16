local M = {
  'mfussenegger/nvim-lint',
}

function M.config()
    require('lint').linters_by_ft = {
        javascript = { 'eslint' },
        typescript = { 'eslint' },
        javascriptreact = { 'eslint' },
        typescriptreact = { 'eslint' },
    }
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        callback = function()
            require('lint').try_lint()
        end,
    })
end

return M
