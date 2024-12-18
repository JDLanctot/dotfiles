return {
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy",
            },
            cargo = {
                allFeatures = true,
            },
            procMacro = {
                enable = true,
            },
        },
    },
}
