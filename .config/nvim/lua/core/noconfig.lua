local Ms = {
    -------------------------- VISUAL --------------------------
    {
        'echasnovski/mini.indentscope',
        config = function()
            require("mini.indentscope").setup()
        end
    },

    -- Overlay characters to hide secrets
    "laytan/cloak.nvim",

    -------------------------- VISUAL --------------------------

    ----------------------- Functionality ----------------------
    -- Pairs and tags
    -- {
    --     'windwp/nvim-autopairs',
    --     event = "InsertEnter",
    --     opts = {} -- this is equalent to setup({}) function
    -- },
    "windwp/nvim-ts-autotag",

    -- Multi Line
    "mg979/vim-visual-multi",

    -- AI
    "github/copilot.vim",
    ---------------------- Functionality ----------------------
}

return Ms
