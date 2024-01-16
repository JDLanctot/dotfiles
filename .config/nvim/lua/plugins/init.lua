local Ms = {
    ------------------------ Processes -------------------------
    -- Terminal
    -- {'akinsho/toggleterm.nvim', version = "*", config = true},
    ------------------------ Processes -------------------------

    -------------------------- VISUAL --------------------------
    -- Indenting visual indicator
    {
        'echasnovski/mini.indentscope',
        config = function()
            require("mini.indentscope").setup()
        end
    },

    -- Overlay characters to hide secrets
    "laytan/cloak.nvim",

    -- Useless screen saver kind of effect
    "eandrju/cellular-automaton.nvim",
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

    -- Undo
    "mbbill/undotree",

    -- AI
    "github/copilot.vim",
    ---------------------- Functionality ----------------------
}

return Ms
