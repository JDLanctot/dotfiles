local M = {
    'rose-pine/neovim',
    name = 'rose-pine',
}

function M.config()
    -- vim.cmd('colorscheme rose-pine')
    require('rose-pine').setup({
        disable_background = true
    })
    ColorMyPencils()
end

function ColorMyPencils(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return M
