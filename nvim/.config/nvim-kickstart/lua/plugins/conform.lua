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
			-- format_on_save = function(bufnr)
			-- 	-- Disable "format_on_save lsp_fallback" for languages that don't
			-- 	-- have a well standardized coding style. You can add additional
			-- 	-- languages here or re-enable it for the disabled ones.
			-- 	local disable_filetypes = { c = true, cpp = true }
			-- 	if disable_filetypes[vim.bo[bufnr].filetype] then
			-- 		return nil
			-- 	else
			-- 		return {
			-- 			timeout_ms = 500,
			-- 			lsp_format = "fallback",
			-- 		}
			-- 	end
			-- end,
			formatters_by_ft = {
				c = { "clang-format" },
				cpp = { "clang-format" },
				go = { "goimports", "gofumpt" },
				java = { "google-java-format" },
				lua = { "stylua" },
				python = { "ruff_format" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				css = { "prettier" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				-- Rust: Uses the built-in rustfmt
				rust = { "rustfmt" },

				-- SQL: Use sql-formatter for standard SQL cleanup
				sql = { "sql-formatter" },

				-- JSON & HTML: Prettier is the best choice here
				json = { "prettier" },
				html = { "prettier" },
			},
		},
	},
}
