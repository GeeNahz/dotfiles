if true then return {} end -- this disables the plugin

return {
  'dense-analysis/ale',
  config = function()
    -- Configuration goes here.
    local g = vim.g

    g.ale_ruby_rubocop_auto_correct_all = 1

    g.ale_linters = {
      ruby = { 'rubocop', 'ruby' },
      lua = { 'lua_language_server' },
      python = { 'flake8', 'pyright' },
      javascript = { 'eslint', 'tsserver' },
      typescript = { 'eslint', 'tsserver' },
      typescriptreact = { 'eslint', 'tsserver' },
      json = { 'jsonls' },
      markdown = { 'alex' },
      html = { 'htmlhint' },
      gleam = { 'gleam' },
      elixir = { 'elixir-ls' },
      erlang = { 'erlangls' },
      go = { 'gopls' },
      dockerfile = { 'hadolint' }
    }
  end
}
