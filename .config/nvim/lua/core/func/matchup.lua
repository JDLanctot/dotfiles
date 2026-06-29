local M = {
    "andymass/vim-matchup",
    event = "BufReadPost",
    init = function()
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
        vim.g.matchup_surround_enabled = 1
        vim.g.matchup_transmute_enabled = 1
        vim.g.matchup_matchparen_deferred = 1
        vim.g.matchup_matchparen_hi_surround_always = 1
        vim.g.matchup_treesitter_disabled = { "markdown" }
    end,
}

return M
