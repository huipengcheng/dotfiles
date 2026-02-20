return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			formatters_by_ft = {
				c = { "clang-format" },
				cpp = { "clang-format" },
				go = { "goimports", "gofumpt" },
				java = { "google-java-format" },
				lua = { "stylua" },
				python = { "ruff_format" },
				rust = { "rustfmt" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				sql = { "sql-formatter" },
				json = { "prettier" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
			},
		},
	},
}
