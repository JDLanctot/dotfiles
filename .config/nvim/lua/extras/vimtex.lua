local M = { "lervag/vimtex", ft = { "tex", "plaintex", "latex" } }

function M.config()
  -- Viewer (Sumatra) + compiler (Tectonic)
  if vim.fn.has("macunix") == 1 then
    vim.g.vimtex_view_method = "sioyek"
  elseif vim.fn.has("win32") == 1 then
    vim.g.vimtex_view_method = "sumatra"
    vim.g.vimtex_view_general_viewer = "SumatraPDF"
    vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
  end
  vim.g.vimtex_quickfix_mode = 0

  vim.g.vimtex_compiler_method = "tectonic"
  vim.g.vimtex_compiler_tectonic = {
    build_dir = "build",
    args = {
      "-X", "compile", "%f",
      "--synctex",
      "--keep-logs", "--keep-intermediates",
      "--outdir", "build",
    },
  }

  -- Keymaps (buffer-local) for TeX
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "tex", "plaintex", "latex" },
    callback = function(ev)
      local buf = ev.buf
      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = buf, noremap = true, silent = true, desc = desc })
      end
      local function cmd(c) return function() vim.cmd(c) end end

      -- Compile / view
      map("<leader>lc", cmd("VimtexCompile"),   "LaTeX: compile (continuous)")
      map("<leader>lb", cmd("VimtexCompileSS"), "LaTeX: build once")
      map("<leader>ls", cmd("VimtexStop"),      "LaTeX: stop compiler")
      map("<leader>lv", cmd("VimtexView"),      "LaTeX: view (forward search)")
      map("<leader>lq", cmd("VimtexErrors"),    "LaTeX: open errors (quickfix)")
      map("<leader>la", cmd("VimtexClean!"),    "LaTeX: clean aux files (deep)")
      map("<leader>lr", cmd("VimtexReload"),    "LaTeX: reload project")

      -- Lint / diagnostics (nvim-lint + built-in diagnostics)
      map("<leader>ll", function()
        pcall(require, "lint")
        if package.loaded["lint"] then require("lint").try_lint() end
      end, "LaTeX: run vale")

      map("<leader>ld", function()
        vim.diagnostic.open_float(nil, { scope = "line", focusable = false })
      end, "LaTeX: line diagnostics")

      map("<leader>lm", function()
        vim.diagnostic.setloclist({ open = true })
      end, "LaTeX: diagnostics loclist")
    end,
  })
end

return M
