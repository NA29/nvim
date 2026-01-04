return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1001,
  config = function()
    require("tokyonight").setup({
      transparent = true,
    })
    vim.cmd.colorscheme("tokyonight")
  end

}
