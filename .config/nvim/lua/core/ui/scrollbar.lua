local M = {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    config = function()
        require("scrollbar").setup({
            show = true,
            show_in_active_only = true,
            set_highlights = true,
            handle = {
                text = " ",
                color = nil,
                cterm = nil,
                highlight = "CursorColumn",
                hide_if_all_visible = true,
            },
            marks = {
                Search = {
                    text = { "-", "=" },
                    priority = 0,
                    color = nil,
                    cterm = nil,
                    highlight = "Search",
                },
                Error = {
                    text = { "-", "=" },
                    priority = 1,
                    color = nil,
                    cterm = nil,
                    highlight = "DiagnosticVirtualTextError",
                },
                Warn = {
                    text = { "-", "=" },
                    priority = 2,
                    color = nil,
                    cterm = nil,
                    highlight = "DiagnosticVirtualTextWarn",
                },
                Info = {
                    text = { "-", "=" },
                    priority = 3,
                    color = nil,
                    cterm = nil,
                    highlight = "DiagnosticVirtualTextInfo",
                },
                Hint = {
                    text = { "-", "=" },
                    priority = 4,
                    color = nil,
                    cterm = nil,
                    highlight = "DiagnosticVirtualTextHint",
                },
                Misc = {
                    text = { "-", "=" },
                    priority = 5,
                    color = nil,
                    cterm = nil,
                    highlight = "Normal",
                },
            },
            excluded_buftypes = {
                "terminal",
            },
            excluded_filetypes = {
                "prompt",
                "TelescopePrompt",
                "noice",
                "neo-tree",
            },
            autocmd = {
                render = {
                    "BufWinEnter",
                    "TabEnter",
                    "TermEnter",
                    "WinEnter",
                    "CmdwinLeave",
                    "TextChanged",
                    "VimResized",
                    "WinScrolled",
                },
                clear = {
                    "TabLeave",
                    "TermLeave",
                    "WinLeave",
                },
            },
            handlers = {
                cursor = true,
                diagnostic = true,
                gitsigns = true,
                handle = true,
                search = true,
            },
        })
    end,
    dependencies = {
        "lewis6991/gitsigns.nvim",
    },
}

return M
