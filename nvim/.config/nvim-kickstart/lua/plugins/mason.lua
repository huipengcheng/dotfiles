return {
  {
    "mason-org/mason.nvim",
    opts = {},
    -- config = function(_, opts)
    --   require("mason").setup(opts)

    --   -- 让 nvim-lint / formatter 等能直接找到 mason 装的命令
    --   -- Windows 用 ;，类 Unix 用 :
    --   local sep = (vim.fn.has("win32") == 1) and ";" or ":"
    --   local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
    --   if not string.find(vim.env.PATH or "", mason_bin, 1, true) then
    --     vim.env.PATH = mason_bin .. sep .. (vim.env.PATH or "")
    --   end
    -- end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {},
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        -- LSP
        "clangd",
        "gopls",
        "basedpyright",
        "ruff",
        "lua_ls",
        "rust_analyzer",
        "vtsls",
        "jdtls",
        "bashls",
        "jsonls",
        "cssls",
        "sqls",
        "html",

        -- DAP
        "debugpy",
        "codelldb",
        "delve",

        -- format / lint / misc
        "stylua",
        "clang-format",
        "google-java-format",
        "goimports",
        "gofumpt",
        "prettier",
        "shfmt",
        "sql-formatter",

        "shellcheck",
        "cpplint",
        "markdownlint",
        "pylint",
      },
      auto_update = false,
      run_on_start = true,
    },
  },
}

