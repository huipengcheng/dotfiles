
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  config = function()

    require("ibl").setup({
      indent = {
        char = "▎",
        tab_char = "▎",
      },
      scope = {
        enabled = false,
        show_start = true,
        show_end = false,
      },
    })
  end,
}
