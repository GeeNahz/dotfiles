vim.cmd("set expandtab") -- convert tabs to spaces
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set relativenumber") -- relative line numbers
vim.cmd("set foldmethod=indent") -- code fold method 'indent' | 'syntax' | 'marker'
vim.cmd("set foldlevel=2") -- code fold level
vim.cmd("set foldlevelstart=0") -- code fold on buffer open
vim.cmd("set foldnestmax=5") -- limits the maximum number of nested folds

vim.g.background = "light"

vim.opt.encoding = 'utf-8' -- set encoding

vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- unless capital letter in search

vim.opt.swapfile = false -- disable swapfile
vim.wo.number = true

vim.opt.scrolloff = 8 -- minimum number of lines to keep above and below the cursor
vim.opt.sidescrolloff = 8 -- minimum number of lines to keep above and below the cursor

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = '*.py',
  callback = function()
    vim.opt.textwidth = 79
    vim.opt.colorcolumn = '79'
  end
}) -- python formatting

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = {'*.js', '*.ts', '*.html', '*.css', '*.lua', '*.jsx', '*.tsx'},
  callback = function()
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
  end,
}) -- js, ts, lua, formatting

vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd("normal! g`\"")
    end
  end
}) -- return to last edit position when opening files
