return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = {
        enabled = false,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.options.numbers = "ordinal"
      opts.options.separator_style = "slant"
      return opts
    end,
  },
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        view = "cmdline",
      },
      views = {
        notify = {
          backend = { "notify", "snacks" },
        },
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      render = "wrapped-compact",
      max_width = 50,
      stages = "static",
    },
  },
}
