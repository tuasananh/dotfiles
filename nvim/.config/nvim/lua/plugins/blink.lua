return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "default",
      -- Disable Enter (<CR>) from accepting suggestions
      ["<CR>"] = { "fallback" },
      -- Optional: Ensure Tab or other keys work as you expect
      -- ["<Tab>"] = { "fallback" },
      -- ["<S-Tab>"] = { "select_prev", "fallback" },
    },
  },
}
