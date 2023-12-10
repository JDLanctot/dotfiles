-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/toofaeded/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/toofaeded/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/toofaeded/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/toofaeded/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/toofaeded/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["alpha-nvim"] = {
    config = { "\27LJ\2\2â\1\0\0\t\0\14\0\0266\0\0\0009\0\1\0006\1\2\0B\0\2\2\21\0\0\0006\1\3\0009\1\4\1'\2\5\0B\1\2\0026\2\0\0009\2\6\2B\2\1\2'\3\a\0009\4\b\2'\5\t\0009\6\n\2'\a\t\0009\b\v\2&\3\b\3\18\4\1\0'\5\f\0\18\6\0\0'\a\r\0\18\b\3\0&\4\b\4L\4\2\0\r plugins\v  ï \npatch\nminor\6.\nmajor\f  ï§ v\fversion\31ï %d-%m-%Y  î %H:%M:%S\tdate\aos\19packer_plugins\rtbl_keys\bvim\16\1\0\t\0006\1i6\0\0\0'\1\1\0B\0\2\0026\1\0\0'\2\2\0B\1\2\0023\2\3\0009\3\4\0019\3\5\0035\4\a\0=\4\6\0039\3\4\0019\3\b\0034\4\r\0009\5\t\1'\6\n\0'\a\v\0'\b\f\0B\5\4\2>\5\1\0049\5\t\1'\6\r\0'\a\14\0'\b\15\0B\5\4\2>\5\2\0049\5\t\1'\6\16\0'\a\17\0'\b\18\0B\5\4\2>\5\3\0049\5\t\1'\6\19\0'\a\20\0'\b\21\0B\5\4\2>\5\4\0049\5\t\1'\6\22\0'\a\23\0'\b\24\0B\5\4\2>\5\5\0049\5\t\1'\6\25\0'\a\26\0'\b\27\0B\5\4\2>\5\6\0049\5\t\1'\6\28\0'\a\29\0'\b\30\0B\5\4\2>\5\a\0049\5\t\1'\6\31\0'\a \0'\b!\0B\5\4\2>\5\b\0049\5\t\1'\6\"\0'\a#\0'\b$\0B\5\4\2>\5\t\0049\5\t\1'\6%\0'\a&\0'\b'\0B\5\4\2>\5\n\0049\5\t\1'\6(\0'\a)\0'\b*\0B\5\4\2>\5\v\0049\5\t\1'\6+\0'\a,\0'\b-\0B\5\4\0?\5\0\0=\4\6\0039\3\4\0019\3.\3\18\4\2\0B\4\1\2=\4\6\0039\3\4\0019\3.\0039\3/\3'\0041\0=\0040\0036\0032\0009\0033\3'\0044\0B\3\2\0019\0035\0009\4/\1B\3\2\1K\0\1\0\nsetup3 autocmd FileType alpha setlocal nofoldenable \bcmd\bvim\rConstant\ahl\topts\vfooter\f:qa<CR>\21ï  > Quit NVIM\6q\14<leader>f\23ï  > Format File\tâµf\14<leader>x\27ï  > Make Executable\tâµx\14<leader>p ï  > Paste from Clipboard\tâµp\14<leader>y\29ï  > Copy to Clipboard\tâµy\17<leader>svwm\28ï¾  > Stop Vim-With-Me\fâµsvwm\16<leader>vwm\29ï½  > Start Vim-With-Me\vâµvwm\15<leader>pv\31ï  > Open Project Viewer\nâµpv;:e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>\20î  > Settings\6s\28:Telescope oldfiles<CR>\18ï  > Recent\6r3:cd $HOME/Workspace | Telescope find_files<CR>\21ï  > Find file\6f :ene <BAR> startinsert <CR>\20ï  > New file\6e\vbutton\fbuttons\1\t\0\0:                                                     \1  ââââ   âââââââââââ âââââââ âââ   ââââââââââ   ââââ \1  âââââ  âââââââââââââââââââââââ   âââââââââââ âââââ \1  ââââââ âââââââââ  âââ   ââââââ   âââââââââââââââââ \1  ââââââââââââââââ  âââ   âââââââ ââââââââââââââââââ \1  âââ âââââââââââââââââââââââ âââââââ ââââââ âââ âââ \1  âââ  âââââââââââââ âââââââ   âââââ  ââââââ     âââ :                                                     \bval\vheader\fsection\0\27alpha.themes.dashboard\nalpha\frequire\25À\4\0" },
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/alpha-nvim",
    url = "https://github.com/goolord/alpha-nvim"
  },
  ["cellular-automaton.nvim"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/cellular-automaton.nvim",
    url = "https://github.com/eandrju/cellular-automaton.nvim"
  },
  ["cloak.nvim"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/cloak.nvim",
    url = "https://github.com/laytan/cloak.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["copilot.vim"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/copilot.vim",
    url = "https://github.com/github/copilot.vim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  harpoon = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/harpoon",
    url = "https://github.com/theprimeagen/harpoon"
  },
  ["lsp-zero.nvim"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/lsp-zero.nvim",
    url = "https://github.com/VonHeikemen/lsp-zero.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-tree.lua"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/nvim-tree/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/nvim-treesitter-context",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-context"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/nvim-tree/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["refactoring.nvim"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/refactoring.nvim",
    url = "https://github.com/theprimeagen/refactoring.nvim"
  },
  ["rose-pine"] = {
    config = { "\27LJ\2\0029\0\0\2\0\3\0\0056\0\0\0009\0\1\0'\1\2\0B\0\2\1K\0\1\0\26colorscheme rose-pine\bcmd\bvim\0" },
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/rose-pine",
    url = "https://github.com/rose-pine/neovim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\2C\0\0\2\0\4\0\a6\0\0\0'\1\1\0B\0\2\0029\0\2\0005\1\3\0B\0\2\1K\0\1\0\1\0\1\nicons\1\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  undotree = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/undotree",
    url = "https://github.com/mbbill/undotree"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["zen-mode.nvim"] = {
    loaded = true,
    path = "/home/toofaeded/.local/share/nvim/site/pack/packer/start/zen-mode.nvim",
    url = "https://github.com/folke/zen-mode.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\2C\0\0\2\0\4\0\a6\0\0\0'\1\1\0B\0\2\0029\0\2\0005\1\3\0B\0\2\1K\0\1\0\1\0\1\nicons\1\nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: rose-pine
time([[Config for rose-pine]], true)
try_loadstring("\27LJ\2\0029\0\0\2\0\3\0\0056\0\0\0009\0\1\0'\1\2\0B\0\2\1K\0\1\0\26colorscheme rose-pine\bcmd\bvim\0", "config", "rose-pine")
time([[Config for rose-pine]], false)
-- Config for: alpha-nvim
time([[Config for alpha-nvim]], true)
try_loadstring("\27LJ\2\2â\1\0\0\t\0\14\0\0266\0\0\0009\0\1\0006\1\2\0B\0\2\2\21\0\0\0006\1\3\0009\1\4\1'\2\5\0B\1\2\0026\2\0\0009\2\6\2B\2\1\2'\3\a\0009\4\b\2'\5\t\0009\6\n\2'\a\t\0009\b\v\2&\3\b\3\18\4\1\0'\5\f\0\18\6\0\0'\a\r\0\18\b\3\0&\4\b\4L\4\2\0\r plugins\v  ï \npatch\nminor\6.\nmajor\f  ï§ v\fversion\31ï %d-%m-%Y  î %H:%M:%S\tdate\aos\19packer_plugins\rtbl_keys\bvim\16\1\0\t\0006\1i6\0\0\0'\1\1\0B\0\2\0026\1\0\0'\2\2\0B\1\2\0023\2\3\0009\3\4\0019\3\5\0035\4\a\0=\4\6\0039\3\4\0019\3\b\0034\4\r\0009\5\t\1'\6\n\0'\a\v\0'\b\f\0B\5\4\2>\5\1\0049\5\t\1'\6\r\0'\a\14\0'\b\15\0B\5\4\2>\5\2\0049\5\t\1'\6\16\0'\a\17\0'\b\18\0B\5\4\2>\5\3\0049\5\t\1'\6\19\0'\a\20\0'\b\21\0B\5\4\2>\5\4\0049\5\t\1'\6\22\0'\a\23\0'\b\24\0B\5\4\2>\5\5\0049\5\t\1'\6\25\0'\a\26\0'\b\27\0B\5\4\2>\5\6\0049\5\t\1'\6\28\0'\a\29\0'\b\30\0B\5\4\2>\5\a\0049\5\t\1'\6\31\0'\a \0'\b!\0B\5\4\2>\5\b\0049\5\t\1'\6\"\0'\a#\0'\b$\0B\5\4\2>\5\t\0049\5\t\1'\6%\0'\a&\0'\b'\0B\5\4\2>\5\n\0049\5\t\1'\6(\0'\a)\0'\b*\0B\5\4\2>\5\v\0049\5\t\1'\6+\0'\a,\0'\b-\0B\5\4\0?\5\0\0=\4\6\0039\3\4\0019\3.\3\18\4\2\0B\4\1\2=\4\6\0039\3\4\0019\3.\0039\3/\3'\0041\0=\0040\0036\0032\0009\0033\3'\0044\0B\3\2\0019\0035\0009\4/\1B\3\2\1K\0\1\0\nsetup3 autocmd FileType alpha setlocal nofoldenable \bcmd\bvim\rConstant\ahl\topts\vfooter\f:qa<CR>\21ï  > Quit NVIM\6q\14<leader>f\23ï  > Format File\tâµf\14<leader>x\27ï  > Make Executable\tâµx\14<leader>p ï  > Paste from Clipboard\tâµp\14<leader>y\29ï  > Copy to Clipboard\tâµy\17<leader>svwm\28ï¾  > Stop Vim-With-Me\fâµsvwm\16<leader>vwm\29ï½  > Start Vim-With-Me\vâµvwm\15<leader>pv\31ï  > Open Project Viewer\nâµpv;:e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>\20î  > Settings\6s\28:Telescope oldfiles<CR>\18ï  > Recent\6r3:cd $HOME/Workspace | Telescope find_files<CR>\21ï  > Find file\6f :ene <BAR> startinsert <CR>\20ï  > New file\6e\vbutton\fbuttons\1\t\0\0:                                                     \1  ââââ   âââââââââââ âââââââ âââ   ââââââââââ   ââââ \1  âââââ  âââââââââââââââââââââââ   âââââââââââ âââââ \1  ââââââ âââââââââ  âââ   ââââââ   âââââââââââââââââ \1  ââââââââââââââââ  âââ   âââââââ ââââââââââââââââââ \1  âââ âââââââââââââââââââââââ âââââââ ââââââ âââ âââ \1  âââ  âââââââââââââ âââââââ   âââââ  ââââââ     âââ :                                                     \bval\vheader\fsection\0\27alpha.themes.dashboard\nalpha\frequire\25À\4\0", "config", "alpha-nvim")
time([[Config for alpha-nvim]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
