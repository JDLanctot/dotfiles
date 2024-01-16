local M = {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
}

function M.config()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    local total_plugins = require("lazy").stats().count

    local function footer()
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
        dashboard.button("<leader>pf", "  > Find file", ":cd $HOME/Workspace | Telescope find_files<CR>"),
        dashboard.button("<leader>ph", "  > Recent Directories", ":Telescope neovim-project discover<CR>"),
        dashboard.button("⎵pv", "  > Open Project Viewer", "<leader>pv"), -- Remapped
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

return M
