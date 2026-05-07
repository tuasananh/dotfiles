return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.keymap = {}
    opts.keymap.preset = "super-tab"
    opts.keymap["<C-y>"] = { "select_and_accept" }
  end,
}
