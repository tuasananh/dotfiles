return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = {}
      opts.keymap.preset = "super-tab"
      opts.keymap["<C-y>"] = { "select_and_accept" }
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })
      require("luasnip.loaders.from_snipmate").lazy_load({ paths = { "./snippets" } })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        prettier = {
          prepend_args = { "--trailing-comma", "none" },
        },
      },
    },
  },
}
