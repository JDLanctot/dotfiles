vim.keymap.set("n", "<leader>gs", ":Git<CR>")

local TooFaeded_Fugitive = vim.api.nvim_create_augroup("TooFaeded_Fugitive", {})

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
    group = TooFaeded_Fugitive,
    pattern = "*",
    callback = function()
        if vim.bo.filetype ~= "fugitive" then
            return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local opts = { buffer = bufnr, remap = false, silent = true }

        local function git_commit_with_message()
            local message = vim.fn.input("Commit message: ")
            if message ~= "" then
                vim.cmd("Git commit -m '" .. vim.fn.shellescape(message) .. "'")
            elseif vim.cmd("Git diff --name-only --cached") then
                print("You haven't staged any files to commit")
            else
                print("Commit aborted: No message provided.")
            end
        end

        vim.keymap.set("n", "<leader>gp", ":Git push<CR>", opts)
        vim.keymap.set("n", "<leader>ga", ":Git add .<CR>", opts)
        vim.keymap.set("n", "<leader>gc", git_commit_with_message, opts)
        vim.keymap.set("n", "<leader>gP", ":Git pull --rebase<CR>", opts)
        vim.keymap.set("n", "<leader>gt", ":Git push -u origin ", opts)
    end,
})
