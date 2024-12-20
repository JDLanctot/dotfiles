return {
    settings = {
        tailwindCSS = {
            experimental = {
                classRegex = {
                    "tw`([^`]*)", -- tw`...`
                    'tw="([^"]*)', -- <div tw="..." />
                    'tw={"([^"}]*)', -- <div tw={"..."} />
                    "tw\\.\\w+`([^`]*)", -- tw.xxx`...`
                    "tw\\(.*?\\)`([^`]*)", -- tw(...)`...`
                },
            },
            includeLanguages = {
                typescript = "javascript",
                typescriptreact = "javascript",
            },
        },
    },
}
