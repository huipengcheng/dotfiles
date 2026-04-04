return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- Required for icons
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true, -- Close Neo-tree if it is the last window left
      filesystem = {
        filtered_items = {
          visible = true, -- Show hidden files (dotfiles) by default
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true, -- Focus the tree on the file you are currently editing
        },
        use_libuv_file_watcher = true, -- Automatically refresh the tree
      },
      window = {
        width = 30,
        mappings = {
          ["<space>"] = "none", -- Disable default space mapping
        },
      },
    })

    -- Toggle Neo-tree with a keymap
    vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<cr>', { desc = 'Toggle [E]xplorer' })
  end,
}
