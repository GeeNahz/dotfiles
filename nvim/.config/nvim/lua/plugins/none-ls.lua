return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,

				--null_ls.builtins.diagnostics.black,

				-- null_ls.builtins.diagnostics.eslint_d,
			},
		})

		-- local my_sources = {}
		-- my_sources.filetypes = { "lua", "python", "javascript", "typescript", "html", "css" }
		-- null_ls.setup({
		--   sources = my_sources
		-- })

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
