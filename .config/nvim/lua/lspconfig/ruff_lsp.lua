return {
    on_attach = function(client, _)
        -- Disable hover in favor of other Python LSPs
        client.server_capabilities.hoverProvider = false
    end,
    init_options = {
        settings = {
            -- Ruff settings
            args = {},
        }
    }
}
