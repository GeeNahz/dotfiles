return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		-- local configs = require("nvim-treesitter.configs")
		local configs = require("nvim-treesitter")

		-- configs.setup({}) doesn't really work anymore with updated
		-- treesitter (nvim-treesitter)
		configs.setup({
			ensure_installed = {
				"gleam",
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"elixir",
				"heex",
				"javascript",
				"typescript",
				"html",
				"eex",
				"markdown",
				"markdown_inline",

				"yaml",
				"tsx",
				"json",
			},
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
		})

		configs.install({
			"gleam",
			"c",
			"lua",
			"vim",
			"vimdoc",
			"query",
			"elixir",
			"heex",
			"javascript",
			"html",
			"eex",
			"markdown",
			"markdown_inline",
		})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(ev)
				-- syntax highlighting
				pcall(vim.treesitter.start, ev.buf)

				-- folds
				vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo[0][0].foldmethod = "indent"

				-- indentation <experimental>
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
