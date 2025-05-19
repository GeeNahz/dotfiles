vim.opt.termguicolors = true  -- bufferline
require("bufferline").setup { -- bufferline
  options = {
    mode = "buffers",
    buffer_close_icon = '', -- '󰅖'
    close_icon = '',
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local s = " "
      for e, n in pairs(diagnostics_dict) do
        local sym = e == "error" and " "
            or (e == "warning" and " " or " ")
        s = s .. n .. sym
      end
      return s
    end,
    separator_style = "thick",    -- | "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
    enforce_regular_tabs = false, -- | false | true,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "center", -- | "center" | "left" | "right"
        highlight = "Directory",
        separator = true
      }
    },
    sort_by = 'insert_at_end', -- | 'insert_at_end' | 'insert_after_current' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs'
  },
}

-- diagnostics_indicator = function(count, level)
--   local icon = level:match("error") and " " or " "
--   return " " .. icon .. count
-- end,
