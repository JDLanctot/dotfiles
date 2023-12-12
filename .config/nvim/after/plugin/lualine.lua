local colors = {
    red = '#ca1243',
    grey = '#a0a1a7',
    black = '#383a42',
    white = '#f3f3f3',
    light_green = '#83a598',
    orange = '#fe8019',
    green = '#8ec07c',
}

local function modified()
    if vim.bo.modified then
        return '+'
    elseif vim.bo.modifiable == false or vim.bo.readonly == true then
        return '-'
    end
    return ''
end

require('lualine').setup {
    icons_enabled = true,
    sections = {
        lualine_a = { 'mode' },
        lualine_b = {
            {
                'filename',
                path = 3
            }
        },
        lualine_c = {
            {
                'diagnostics',
                sources = { 'nvim_diagnostic' },
                sections = { 'error', 'warn', 'info', 'hint' },
                diagnostics_color = {
                    error = { fg = colors.red },
                    warn  = { fg = colors.orange },
                    info  = { fg = colors.white },
                    hing  = { fg = colors.blue },
                },
                symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
                colored = true,
                update_in_insert = false,
            }
        },
        lualine_x = {},
        lualine_y = {
            'branch',
            {
                'diff',
                symbols = { added = ' ', modified = '~ ', removed = ' ' },
                diff_color = {
                    added = { fg = colors.green },
                    modified = { fg = colors.orange },
                    removed = { fg = colors.red },
                }
            }
        },
        lualine_z = { 'filetype' },
    },
}
