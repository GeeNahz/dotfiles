-- spacebar leader key
vim.g.mapleader = " "

-- Navigate vim panes better
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>')

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')

-- buffers
vim.keymap.set('n', '<leader>n', ':bn<CR>')
vim.keymap.set('n', '<leader>p', ':bp<CR>')
vim.keymap.set('n', '<leader>x', ':bd<CR>')

-- yank to clipboard
vim.keymap.set({'n', 'v'}, '<leader>y', [["+y]])

-- LSP
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, {})
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
vim.keymap.set('n', '<leader>gf', vim.lsp.buf.format, {})
