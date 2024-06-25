return {
  "mfussenegger/nvim-lint",
  event = "BufWritePost",
  config = function ()
    -- Define a table of linters for each filetype (not extension).
    require("lint").linters_by_ft = {
      python = {
        "flake8",
        "mypy",
        "pylint",
      }
    }

    -- Additionally run linters after saving
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      -- Only run linters for the following extensions.
      pattern = {"*.py"},
      callback = function ()
        require("lint").try_lint()
      end,
    })
  end
}
