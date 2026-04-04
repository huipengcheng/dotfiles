return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- this will only start session saving when an actual file was opened
  opts = {
    -- add any custom options here
  },
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Session: Load" },
    { "<leader>qS", function() require("persistence").load() end, desc = "Session: Select to Load" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Session: Load The Last" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Session: Stop persist" },
  },
}
