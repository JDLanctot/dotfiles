return {
    ------------------------ Processes -------------------------
    -- Terminal
    {'akinsho/toggleterm.nvim', version = "*", config = true},
    ------------------------ Processes -------------------------

    -------------------------- VISUAL --------------------------
    -- Indenting visual indicator
    { 'echasnovski/mini.indentscope', version = '*' },

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
    ----------------------- Functionality ----------------------

    --------------------------- LSP ----------------------------
    -- LSP
    --[[{
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    },--]]
    --------------------------- LSP ----------------------------
}
