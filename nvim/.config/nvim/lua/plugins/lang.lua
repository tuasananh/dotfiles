return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = function(_, opts)
      return {
        code = {
          sign = false,
          border = "thick",
        },

        heading = {
          sign = false,
        },
      }
    end,
  },
  {
    "lervag/vimtex",
    config = function()
      vim.g.vimtex_view_method = "zathura"
    end,
  },
  {
    "let-def/texpresso.vim",
  },
}
