local M = {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = "VimEnter",
}

function M.config()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    local icons = require("toofaeded.icons")
    -- Fix: Import the ASCII art correctly
    local ascii_art = require("extras.ghosts")
    local total_plugins = require("lazy").stats().count

    local function footer()
        local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
        local version = vim.version()
        local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

        return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info
    end

    -- Fix: Use the correct reference to header
    dashboard.section.header.val = ascii_art.header.val
    -- Apply the highlight groups from your ASCII art
    dashboard.section.header.opts.hl = ascii_art.header.opts.hl

    -- Create buttons with proper shortcuts - no empty separators
    dashboard.section.buttons.val = {
        dashboard.button("e", "  " .. icons.ui.NewFile .. "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("SPC pf", "  " .. icons.ui.Search .. "  Find file", ":Telescope find_files<CR>"),
        dashboard.button("C-p", "  " .. icons.git.Repo .. "  Git files", ":Telescope git_files<CR>"),
        dashboard.button("SPC pb", "  " .. icons.ui.Tab .. "  Buffers", ":Telescope buffers<CR>"),
        dashboard.button("SPC bd", "  " .. icons.ui.Close .. "  Close buffer", ":bd<CR>"),
        dashboard.button("SPC ba", "  " .. icons.ui.BoldClose .. "  Close all buffers", ":%bd<CR>"),
        dashboard.button("SPC ph", "  " .. icons.ui.History .. "  Recent projects", ":Telescope neovim-project history<CR>"),
        dashboard.button("SPC pd", "  " .. icons.ui.Search .. "  Discover projects", ":Telescope neovim-project discover<CR>"),
        dashboard.button("SPC ps", "  " .. icons.ui.Search .. "  Find text", ":Telescope grep_string<CR>"),
        dashboard.button("C-g", "  " .. icons.ui.Tree .. "  File tree", ":NvimTreeToggle<CR>"),
        dashboard.button("SPC gg", "  " .. icons.git.Branch .. "  LazyGit", ":LazyGit<CR>"),
        dashboard.button("SPC gd", "  " .. icons.git.Diff .. "  Git diff", ":DiffviewOpen<CR>"),
        dashboard.button("SPC a", "  " .. icons.ui.Plus .. "  Add to harpoon", ""),
        dashboard.button("C-e", "  " .. icons.ui.Target .. "  Harpoon menu", ""),
        dashboard.button("SPC u", "  " .. icons.ui.History .. "  Undo tree", ":UndotreeToggle<CR>"),
        dashboard.button("SPC tt", "  " .. icons.ui.Bug .. "  Trouble toggle", ""),
        dashboard.button("SPC f", "  " .. icons.ui.Gear .. "  Format file", ""),
        dashboard.button("SPC t", "  " .. icons.ui.Code .. "  Terminal", ":ToggleTerm<CR>"),
        dashboard.button("q", "  " .. icons.ui.SignOut .. "  Quit NVIM", ":qa<CR>")
    }

    -- Set footer
    dashboard.section.footer.val = footer()

    -- Set up highlight groups with purple theme (fallback colors)
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"

    -- Configure fallback colors (in case the ASCII art colors don't work)
    vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#a16be8" })
    vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#7c3aed" })
    vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#8b5cf6" })
    vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#6366f1" })

    -- Auto-open dashboard when starting with nvim .
    local function should_skip()
        -- Skip if we have specific files as arguments (not directories)
        if vim.fn.argc() > 0 then
            for i = 0, vim.fn.argc() - 1 do
                local arg = vim.fn.argv(i)
                -- If we have a specific file (not . or directory), skip dashboard
                if arg ~= "." and vim.fn.isdirectory(arg) == 0 then
                    return true
                end
            end
        end

        -- Skip if buffer has content (but allow empty buffer names)
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname ~= "" and vim.fn.filereadable(bufname) == 1 then
            -- Only skip if file has actual content
            if vim.fn.line("$") > 1 or vim.fn.getline(1):len() > 0 then
                return true
            end
        end

        return false
    end

    -- Configure alpha with full width
    dashboard.opts.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
    }
    dashboard.opts.opts.noautocmd = true
    dashboard.opts.opts.margin = 5  -- Reduce margins for wider display

    -- Auto-open dashboard - delay to let session manager finish first
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            -- Add a small delay to let session restoration complete
            vim.defer_fn(function()
                -- Double-check we should show dashboard after session restoration
                local current_buf = vim.api.nvim_get_current_buf()
                local buf_name = vim.api.nvim_buf_get_name(current_buf)
                local buf_filetype = vim.api.nvim_buf_get_option(current_buf, "filetype")

                -- Show dashboard if:
                -- 1. No specific file arguments were passed, OR
                -- 2. We opened with "nvim ." or just "nvim", AND
                -- 3. Current buffer is empty or is netrw (directory listing)
                local should_show = not should_skip() and
                    (buf_name == "" or buf_filetype == "netrw" or
                     (vim.fn.line("$") == 1 and vim.fn.getline(1) == ""))

                if should_show then
                    require("alpha").start()
                end
            end, 100) -- 100ms delay
        end,
    })

    -- Disable folding on alpha buffer
    vim.cmd([[ autocmd FileType alpha setlocal nofoldenable ]])

    -- Manual dashboard toggle keymap
    vim.keymap.set("n", "<leader>h", function()
        require("alpha").start()
    end, { desc = "Open Dashboard" })

    -- Send config to alpha
    alpha.setup(dashboard.opts)
end

return M
