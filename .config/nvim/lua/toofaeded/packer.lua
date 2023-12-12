-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use({
        "coffebar/neovim-project",
        config = function()
            -- enable saving the state of plugins in the session
            vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
            -- setup neovim-project plugin
            require("neovim-project").setup {
                projects = { -- define project roots
                    "~/research/*",
                    "~/.config/*",
                    "~/webdev/*"
                },
            }
        end,
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
            { "Shatur/neovim-session-manager" },
        }
    })

    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    use({
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup {
                icons = false,
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    })

    use({
        "nvim-tree/nvim-tree.lua",
        requires = {
            'nvim-tree/nvim-web-devicons',
        },
    })

    use {
        "echasnovski/mini.indentscope",
        config = function()
            require("mini.indentscope").setup()
        end
    }

    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }
    use("windwp/nvim-ts-autotag")

    use("mg979/vim-visual-multi")
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use("nvim-treesitter/playground")
    use("theprimeagen/harpoon")
    use("theprimeagen/refactoring.nvim")
    use("mbbill/undotree")
    use("tpope/vim-fugitive")
    use("nvim-treesitter/nvim-treesitter-context");

    use {
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
    }

    use {
        "folke/todo-comments.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        }
    }
    use("folke/zen-mode.nvim")

    use("numToStr/Comment.nvim")
    use("github/copilot.vim")
    use("eandrju/cellular-automaton.nvim")
    use("laytan/cloak.nvim")

    use {
        'goolord/alpha-nvim',
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            local function footer()
                local total_plugins = #vim.tbl_keys(packer_plugins)
                local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
                local version = vim.version()
                local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

                return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info
            end

            -- Set header
            dashboard.section.header.val = { "                                                     ",
                "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
                "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
                "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
                "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
                "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
                "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
                "                                                     " }

            -- Set menu
            dashboard.section.buttons.val = { dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("f", "  > Find file", ":cd $HOME/Workspace | Telescope find_files<CR>"),
                dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
                dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
                dashboard.button("⎵pv", "  > Open Project Viewer", "<leader>pv"), -- Remapped
                dashboard.button("⎵vwm", "  > Start Vim-With-Me", "<leader>vwm"), -- Remapped
                dashboard.button("⎵svwm", "  > Stop Vim-With-Me", "<leader>svwm"), -- Remapped
                dashboard.button("⎵y", "  > Copy to Clipboard", "<leader>y"), -- Remapped
                dashboard.button("⎵p", "  > Paste from Clipboard", "<leader>p"), -- Remapped
                dashboard.button("⎵x", "  > Make Executable", "<leader>x"), -- Remapped
                dashboard.button("⎵f", "  > Format File", "<leader>f"), -- Remapped
                dashboard.button("q", "  > Quit NVIM", ":qa<CR>") }

            -- Set footer
            dashboard.section.footer.val = footer()
            dashboard.section.footer.opts.hl = "Constant"

            -- Disable folding on alpha buffer
            vim.cmd([[ autocmd FileType alpha setlocal nofoldenable ]])

            -- Send config to alpha
            alpha.setup(dashboard.opts)
        end
    }
end)
