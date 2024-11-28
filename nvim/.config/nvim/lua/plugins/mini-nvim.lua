return {
  {
    'echasnovski/mini.animate',
    version = '*',
    config = function()
      local mini_animate = require('mini.animate')
      mini_animate.setup({
        -- Cursor path
        cursor = {
          -- Whether to enable this animation
          enable = true,
        },

        -- Vertical scroll
        scroll = {
          -- Whether to enable this animation
          enable = true,
        },

        -- Window resize
        resize = {
          -- Whether to enable this animation
          enable = true,
        },

        -- Window open
        open = {
          -- Whether to enable this animation
          enable = true,
        },

        -- Window close
        close = {
          -- Whether to enable this animation
          enable = true,
        },
      });
    end
  },
  {
    'echasnovski/mini.pairs',
    version = '*',
    config = function()
      local mini_pairs = require('mini.pairs')
      mini_pairs.setup({});
    end
  },
  -- { 'echasnovski/mini.bracketed', version = '*' },
}
