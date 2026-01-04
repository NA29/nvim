return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("barbecue").setup({
      show_dirname = true,
      show_basename = true,
      show_modified = true,
      symbols = { separator = " › " },
    })
  end,
}
