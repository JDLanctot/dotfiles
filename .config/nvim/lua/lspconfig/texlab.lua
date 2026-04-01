local forward_search

if vim.fn.has("macunix") == 1 then
  forward_search = {
    executable = "sioyek",
    args = { "--forward-search-file", "%f", "--forward-search-line", "%l", "%p" },
  }
else
  forward_search = {
    executable = "SumatraPDF.exe", -- assumes on PATH (Chocolatey usually adds it)
    args = { "-reuse-instance", "-forward-search", "%f", "%l", "%p" },
  }
end

return {
  settings = {
    texlab = {
      auxDirectory = "build",

      -- Let you run :TexlabBuild manually (vimtex can be your continuous builder)
      build = {
        executable = "tectonic",
        args = {
          "-X", "compile", "%f",
          "--synctex",
          "--keep-logs", "--keep-intermediates",
          "--outdir", "build",
        },
        onSave = false,
        forwardSearchAfter = false,
      },

      -- We lint with nvim-lint/vale to avoid duplicate diagnostics
      vale = { onOpenAndSave = false, onEdit = false },

      -- If you install latexindent (not bundled with Tectonic), formatting will work
      latexFormatter = "latexindent",
      latexindent = { ["local"] = nil, modifyLineBreaks = true },

      forwardSearch = forward_search,

      diagnosticsDelay = 300,
    },
  },
}
