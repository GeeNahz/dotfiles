return {
  'stevearc/conform.nvim',
  opts = {},
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { "rustfmt", lsp_format = "fallback" },
        -- Conform will run the first available formatter
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      },
      -- format_on_save = {   -- blocked editor until formatter finished (async = false)
      --   lsp_fallback = true,
      --   lsp_format = "fallback",
      --   async = false,
      --   timeout_ms = 1000,
      -- },
      format_after_save = {  -- non-blocking: file saves instantly, formatter runs after
        lsp_format = "fallback",
      },
    })
  end
}
