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
}
