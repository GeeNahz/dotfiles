-- telescope
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fp", ":Telescope git_files<CR>")
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")

-- nvim-tree
vim.keymap.set('n', '<C-n>', ':NvimTreeFindFileToggle<CR>')

-- nvim-tmux-navigator
vim.keymap.set('n', '<C-h>', ':TmuxNavigatorLeft<CR>')
vim.keymap.set('n', '<C-j>', ':TmuxNavigatorDown<CR>')
vim.keymap.set('n', '<C-k>', ':TmuxNavigatorUp<CR>')
vim.keymap.set('n', '<C-l>', ':TmuxNavigatorRight<CR>')

-- markdown preview
vim.keymap.set('n', '<leader>mp', ':MarkdownPreviewToggle<CR>')

-- nvim-comment
vim.keymap.set({'n', 'v'}, '<leader>/', ':CommentToggle<CR>')
