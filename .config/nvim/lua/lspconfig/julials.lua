return {
    settings = {
        julia = {
            lint = {
                run = true,
                missingrefs = "all",
            },
            completionmode = "exportedonly",
            inlayHints = {
                static = {
                    variableTypes = { enabled = true },
                    parameterNames = { enabled = true },
                },
            },
        },
    },
}
