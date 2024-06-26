return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "cssls", "html", "tsserver", "tailwindcss", "vuels", "pyright" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Auto install LSPs, linters, formatters, debuggers
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "black",
          "debugpy",
          "flake8",
          "isort",
          "mypy",
          "pylint",
        },
      })

      -- There is an issue with mason-tools-installer running with VeryLazy
      vim.api.nvim_command("MasonToolsInstall")

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.cssls.setup({
        capabilities = capabilities,
      })
      lspconfig.html.setup({
        capabilities = capabilities,
      })
      lspconfig.tsserver.setup({
        capabilities = capabilities,
      })
      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
      })
      lspconfig.vuels.setup({
        capabilities = capabilities,
      })
      lspconfig.pyright.setup({
        capabilities = capabilities,
      })
      -- lspconfig.pylsp.setup({
      --	capabilities = capabilities,
      -- })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}
