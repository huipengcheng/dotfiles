return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- this will only start session saving when an actual file was opened
  opts = {
    -- add any custom options here
  },
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Load The Session" },
    { "<leader>qS", function() require("persistence").load() end, desc = "Select a Session to Load" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Load The Last Session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Stop Persistence" },
  },
}
