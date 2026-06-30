local M = {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
        vim.g.matchup_surround_enabled = 1
        vim.g.matchup_transmute_enabled = 1
        vim.g.matchup_matchparen_deferred = 1
        vim.g.matchup_matchparen_hi_surround_always = 1
    end,
}

return M
