# Neovim Keybinds

Leader is `Space`.

## Normal Mode

| Keybind | What it does |
| --- | --- |
| `<leader>pv` | Open netrw file explorer with `:Ex`. |
| `<C-i>` | Preserve default jump-forward behavior. |
| `J` | Join current line with next line and keep cursor position. |
| `<C-d>` | Move half-page down and center cursor. |
| `<C-u>` | Move half-page up and center cursor. |
| `n` | Next search result, centered and unfolded. |
| `N` | Previous search result, centered and unfolded. |
| `*` | Search word under cursor forward, centered and unfolded. |
| `#` | Search word under cursor backward, centered and unfolded. |
| `g*` | Search partial word under cursor forward, centered and unfolded. |
| `g#` | Search partial word under cursor backward, centered and unfolded. |
| `<leader>y` | Yank to system clipboard. |
| `<leader>Y` | Yank current line to system clipboard. |
| `<leader>d` | Delete to black-hole register. |
| `Q` | Disabled. |
| `<leader>f` | Format current buffer through LSP. |
| `<C-k>` | Jump to next quickfix item and center cursor. |
| `<C-j>` | Jump to previous quickfix item and center cursor. |
| `<leader>k` | Jump to next location-list item and center cursor. |
| `<leader>j` | Jump to previous location-list item and center cursor. |
| `<leader>s` | Start project-wide substitute for word under cursor. |
| `<leader>x` | Run `chmod +x` on the current file. |
| `<leader>vpp` | Edit `~/.config/nvim/lua/toofaeded/lazy.lua`. |
| `<leader>mr` | Run `CellularAutomaton make_it_rain`. |
| `<leader><leader>` | Source the current file. |
| `<C-a>` | Select the entire buffer. |
| `gd` | Go to LSP definition. |
| `gD` | Go to LSP declaration. |
| `gI` | Go to LSP implementation. |
| `gr` | Show LSP references. |
| `gl` | Open diagnostic float. |
| `<leader>K` | Show LSP hover documentation. |
| `<leader>vws` | Search LSP workspace symbols. |
| `<leader>vd` | Open diagnostic float. |
| `<leader>vca` | Run LSP code action. |
| `<leader>vrn` | Rename symbol with LSP. |

## Command Mode

| Keybind | What it does |
| --- | --- |
| `<C-k>` | Select previous completion item in command-line completion. |
| `<C-j>` | Select next completion item in command-line completion. |
| `<Up>` | Select previous completion item in command-line completion. |
| `<Down>` | Select next completion item in command-line completion. |
| `<C-b>` | Scroll completion documentation up. |
| `<C-f>` | Scroll completion documentation down. |
| `<C-Space>` | Trigger completion. |
| `<C-e>` | Close command-line completion. |
| `<C-y>` | Confirm selected completion item. |

## Insert Mode

| Keybind | What it does |
| --- | --- |
| `<C-c>` | Leave insert mode like `<Esc>`. |
| `<C-k>` | Select previous completion item. |
| `<C-j>` | Select next completion item. |
| `<Up>` | Select previous completion item. |
| `<Down>` | Select next completion item. |
| `<C-b>` | Scroll completion documentation up. |
| `<C-f>` | Scroll completion documentation down. |
| `<C-Space>` | Trigger completion. |
| `<C-e>` | Abort completion. |
| `<C-y>` | Confirm selected completion item. |
| `<C-l>` | Select next completion item, expand snippet, or jump forward in snippet. |
| `<C-h>` | Select previous completion item or jump backward in snippet when completion/snippets are active; otherwise falls back, so LSP signature help may run in LSP buffers. |
| `<M-l>` | Accept Copilot suggestion. |
| `<M-j>` | Next Copilot suggestion. |
| `<M-k>` | Previous Copilot suggestion. |
| `<M-h>` | Dismiss Copilot suggestion. |
| `<c-\>` | Toggle ToggleTerm terminal. |

## Splits and Buffers

| Keybind | What it does |
| --- | --- |
| `<M-h>` | Move to left split. |
| `<M-j>` | Move to lower split. |
| `<M-k>` | Move to upper split. |
| `<M-l>` | Move to right split. |
| `<M-Tab>` | Disabled. |
| `<leader>pb` | Pick open buffers with Telescope. |
| `<C-e>` | Toggle Harpoon quick menu. |
| `<C-h>` | Jump to Harpoon item 1. |
| `<C-t>` | Jump to Harpoon item 2. |
| `<C-n>` | Jump to Harpoon item 3. |
| `<C-s>` | Jump to Harpoon item 4. |
| `<C-S-P>` | Go to previous Harpoon item. |
| `<C-S-N>` | Go to next Harpoon item. |
| `<c-g>` | Toggle nvim-tree. |
| `?` | Show nvim-tree help when focused in nvim-tree. |
| `<leader>t` | Toggle default terminal. |
| `<leader>th` | Open horizontal terminal. |
| `<leader>tv` | Open vertical terminal. |
| `<leader>tf` | Open floating terminal. |
| `<M-1>` | Toggle horizontal terminal from normal or terminal mode. |
| `<M-2>` | Toggle vertical terminal from normal or terminal mode. |
| `<M-3>` | Toggle floating terminal from normal or terminal mode. |
| Terminal `<M-h>` | Leave terminal mode and move to left split. |
| Terminal `<M-j>` | Leave terminal mode and move to lower split. |
| Terminal `<M-k>` | Leave terminal mode and move to upper split. |
| Terminal `<M-l>` | Leave terminal mode and move to right split. |
| Terminal `<LeftRelease>` | Re-enter insert mode after mouse release in terminal buffer. |

## Visual Mode

| Keybind | What it does |
| --- | --- |
| `J` | Move selected lines down and reindent. |
| `K` | Move selected lines up and reindent. |
| `<` | Indent left and keep selection. |
| `>` | Indent right and keep selection. |
| `<leader>p` | Paste over selection without replacing default register. |
| `<leader>y` | Yank selection to system clipboard. |
| `<leader>d` | Delete selection to black-hole register. |
| `<leader>ri` | Refactoring.nvim inline variable. |
| `<leader>hs` | Stage selected Git hunk range. |
| `<leader>hr` | Reset selected Git hunk range. |
| `ih` | Select Git hunk text object in visual/operator-pending mode. |
| `s` | Leap forward target in visual/operator-pending mode. |
| `S` | Leap backward target in visual/operator-pending mode. |
| `gs` | Leap target across windows in visual/operator-pending mode. |
| `<C-Space>` | Start or expand Treesitter incremental selection. |
| `<C-s>` | Expand Treesitter selection by scope. |
| `<M-Space>` | Shrink Treesitter selection. |
| `aa` | Select Treesitter parameter outer. |
| `ia` | Select Treesitter parameter inner. |
| `af` | Select Treesitter function outer. |
| `if` | Select Treesitter function inner. |
| `ac` | Select Treesitter class outer. |
| `ic` | Select Treesitter class inner. |

## Plugin-Based

| Keybind | What it does |
| --- | --- |
| `<leader>a` | Add current file to Harpoon list. |
| `<leader>pf` | Telescope find files. |
| `<C-p>` | Telescope Git files. |
| `<leader>pws` | Telescope grep word under cursor. |
| `<leader>pWs` | Telescope grep WORD under cursor. |
| `<leader>ps` | Telescope grep prompted text. |
| `<leader>vh` | Telescope help tags. |
| `<leader>pd` | Telescope project discovery. |
| `<leader>ph` | Telescope project history. |
| `<leader>n` | Telescope notification history. |
| `<leader>h` | Open Alpha dashboard. |
| `<leader>u` | Toggle Undotree. |
| `<leader>tt` | Toggle Trouble. |
| `<leader>tn` | Jump to next Trouble item, skipping groups. |
| `<leader>tp` | Jump to previous Trouble item, skipping groups. |
| `<leader>gd` | Open Diffview. |
| `<leader>gdc` | Close Diffview. |
| `<leader>gg` | Open LazyGit. |
| `<leader>gs` | Open Fugitive Git status. |
| `<leader>gp` | Fugitive Git push from a Fugitive buffer. |
| `<leader>ga` | Fugitive Git add all from a Fugitive buffer. |
| `<leader>gc` | Fugitive Git commit with prompted message from a Fugitive buffer. |
| `<leader>gP` | Fugitive Git pull with rebase from a Fugitive buffer. |
| `<leader>gt` | Start Fugitive push with upstream target from a Fugitive buffer. |
| `]c` | Next Git hunk, or default diff next change in diff mode. |
| `[c` | Previous Git hunk, or default diff previous change in diff mode. |
| `<leader>hs` | Stage current Git hunk. |
| `<leader>hr` | Reset current Git hunk. |
| `<leader>hS` | Stage current buffer. |
| `<leader>hR` | Reset current buffer. |
| `<leader>hp` | Preview Git hunk. |
| `<leader>hi` | Preview Git hunk inline. |
| `<leader>hb` | Show full Git blame for current line. |
| `<leader>hd` | Diff current file against index. |
| `<leader>hD` | Diff current file against previous revision. |
| `<leader>hQ` | Send all Git hunks to quickfix. |
| `<leader>hq` | Send current buffer Git hunks to quickfix. |
| `<leader>tb` | Toggle current-line Git blame. |
| `<leader>tw` | Toggle Git word diff. |
| `]]` | Go to next vim-illuminate reference. |
| `[[` | Go to previous vim-illuminate reference. |
| `gcc` | Toggle line comment with Comment.nvim. |
| `gbc` | Toggle block comment with Comment.nvim. |
| `gc` | Comment operator for line comments. |
| `gb` | Comment operator for block comments. |
| `gcO` | Add comment above current line. |
| `gco` | Add comment below current line. |
| `gcA` | Add comment at end of current line. |
| `]z` | Jump to next todo comment. |
| `[z` | Jump to previous todo comment. |
| `<leader>z` | Open todo comments in Telescope. |
| `s` | Leap forward target. |
| `S` | Leap backward target. |
| `gs` | Leap target across windows. |
| `]m` | Treesitter next function start. |
| `]]` | Treesitter next class start; overridden by vim-illuminate after it loads. |
| `]M` | Treesitter next function end. |
| `][` | Treesitter next class end. |
| `[m` | Treesitter previous function start. |
| `[[` | Treesitter previous class start; overridden by vim-illuminate after it loads. |
| `[M` | Treesitter previous function end. |
| `[]` | Treesitter previous class end. |
| `<leader>s` | Treesitter swap next parameter; may conflict with normal-mode substitute mapping. |
| `<leader>S` | Treesitter swap previous parameter. |
| `<leader>un` | Dismiss all notifications. |
| `<c-s>` | Toggle Copilot auto-trigger. |
| Copilot panel `<M-j>` | Jump to next Copilot panel suggestion. |
| Copilot panel `<M-k>` | Jump to previous Copilot panel suggestion. |
| Copilot panel `<M-l>` | Accept Copilot panel suggestion. |
| Copilot panel `r` | Refresh Copilot panel. |
| Copilot panel `<M-CR>` | Open Copilot panel item. |
| TeX `<leader>lc` | Start VimTeX continuous compile. |
| TeX `<leader>lb` | Run one-shot VimTeX build. |
| TeX `<leader>ls` | Stop VimTeX compiler. |
| TeX `<leader>lv` | View PDF with forward search. |
| TeX `<leader>lq` | Open VimTeX errors in quickfix. |
| TeX `<leader>la` | Deep clean LaTeX aux files. |
| TeX `<leader>lr` | Reload VimTeX project. |
| TeX `<leader>ll` | Run configured LaTeX lint. |
| TeX `<leader>ld` | Open diagnostics float for current line. |
| TeX `<leader>lm` | Open diagnostics location list. |

## Disabled Or Not Currently Spec'd

| Keybind | Status |
| --- | --- |
| Zen Mode `<leader>zz`, `<leader>zZ` | Defined in `lua/extras/zenmode.lua`, but Zen Mode is commented out in `lua/toofaeded/init.lua`. |
| Flash keys | Defined in `lua/extras/flash.lua`, but Flash is commented out in `lua/toofaeded/init.lua`. |
| Tabby keys | Plugin spec is commented out in `lua/toofaeded/init.lua`. |
| Scrollbar keys | Plugin spec is commented out in `lua/toofaeded/init.lua`. |
