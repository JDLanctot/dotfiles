local M = {
    {
        "RRethy/vim-illuminate",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            providers = { "lsp", "regex" },
            delay = 200,
            large_file_cutoff = 2000,
            large_file_overrides = {
                providers = { "lsp" },
            },
            filetype_overrides = {
                julia = { providers = { "lsp" } },
            },
        },
        config = function(_, opts)
            require("illuminate").configure(opts)
            vim.keymap.set("n", "]]", function()
                require("illuminate").goto_next_reference()
            end, { desc = "Next Reference" })
            vim.keymap.set("n", "[[", function()
                require("illuminate").goto_prev_reference()
            end, { desc = "Prev Reference" })
        end,
    },
}

return M
