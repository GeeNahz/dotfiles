return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = true,
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { 'L3MON4D3/LuaSnip' },
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_cmp()

      -- And you can configure cmp even more, if you want to.
      local cmp = require('cmp')
      local cmp_action = lsp_zero.cmp_action()

      cmp.setup({
        formatting = lsp_zero.cmp_format({ details = true }),
        mapping = cmp.mapping.preset.insert({
          ['<C-y>'] = cmp.mapping.confirm(),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-f>'] = cmp_action.luasnip_jump_forward(),
          ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        }),
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "codeium" },
        },
      })
    end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason-lspconfig.nvim' },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    },
    config = function()
      -- This ensures that mason installs the defined linters and formatters
      require("mason-tool-installer").setup({
        ensure_installed = {
          "black",
          "flake8",
          "hadolint",
        },
      })
      -- There is an issue with mason-tools-installer running with VeryLazy
      vim.api.nvim_command("MasonToolsInstall")

      -- This is where all the LSP shenanigans will live
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()

      -- if you want to know more about mason.nvim
      -- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({ buffer = bufnr })
      end)

      local lspconfig = require('lspconfig')

      require('mason-lspconfig').setup({
        ensure_installed = { "lua_ls", "cssls", "html", "ts_ls", "tailwindcss", "vuels", "pyright", "pylsp", "ast_grep", "docker_compose_language_service", "dockerls", },
        handlers = {
          -- this first function is the "default handler"
          -- it applies to every language server without a "custom handler"
          function(server_name)
            lspconfig[server_name].setup({})
          end,

          -- this is the "custom handler" for `lua_ls`
          lua_ls = function()
            -- (Optional) Configure lua language server for neovim
            local lua_opts = lsp_zero.nvim_lua_ls()
            lspconfig.lua_ls.setup(lua_opts)
          end,
        }
      })

      lspconfig.gleam.setup({})

      -- Python environment
      local util = require('lspconfig/util')
      local path = util.path
      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
      lspconfig.pyright.setup({
        capabilities = capabilities,
        before_init = function(_, config)
          local project_venv_name = 'nvim-test' -- change to reflect the specific project name
          local python_path = path.join('bin', 'python3')
          local venv_name = ''

          if vim.env.VIRTUAL_ENV == nil then
            venv_name = path.join(vim.env.HOME, 'Documents', 'virtualenvs', project_venv_name)
          else
            venv_name = vim.env.VIRTUAL_ENV
          end

          venv_name = vim.env.VIRTUAL_ENV

          -- local default_venv_path = path.join(vim.env.HOME, 'Documents', 'virtualenvs', 'nvim-test', 'bin', 'python3')
          local default_venv_path = path.join(venv_name, python_path)
          config.settings.python.pythonPath = default_venv_path
        end
      })
    end
  }
}
