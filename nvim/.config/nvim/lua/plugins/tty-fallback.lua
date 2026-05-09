-- lua/plugins/tty-fallback.lua

local is_tty = os.getenv("TERM") == "linux"
if not is_tty then
  return {}
end

return {
  {
    "nvim-mini/mini.icons",
    opts = { style = "ascii" },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      -- Conditionally load colorscheme:
      -- TTY usually sets TERM="linux" and lacks true-color support.
      -- ---@type string|fun()
      -- colorscheme = function()
      --   if os.getenv("TERM") == "linux" then
      --     vim.cmd([[colorscheme habamax]]) -- Built-in TTY-safe theme
      --   else
      --     require("tokyonight").load()
      --   end
      -- end,

      -- load the default settings
      defaults = {
        autocmds = true, -- lazyvim.config.autocmds
        keymaps = true, -- lazyvim.config.keymaps
      },

      news = {
        lazyvim = true,
        neovim = false,
      },

      -- Replaced Nerd Font icons with standard ASCII for TTY compatibility
      icons = {
        misc = {
          dots = "...",
        },
        ft = {
          octo = "GH ",
          gh = "GH ",
          ["markdown.gh"] = "GH ",
        },
        dap = {
          Stopped = { "-> ", "DiagnosticWarn", "DapStoppedLine" },
          Breakpoint = "B ",
          BreakpointCondition = "? ",
          BreakpointRejected = { "! ", "DiagnosticError" },
          LogPoint = "> ",
        },
        diagnostics = {
          Error = "E ",
          Warn = "W ",
          Hint = "H ",
          Info = "I ",
        },
        git = {
          added = "+ ",
          modified = "~ ",
          removed = "- ",
        },
        kinds = {
          Array = "[T] ",
          Boolean = "[B] ",
          Class = "[C] ",
          Codeium = "[AI] ",
          Color = "[#] ",
          Control = "[*] ",
          Collapsed = "> ",
          Constant = "[c] ",
          Constructor = "[+] ",
          Copilot = "[AI] ",
          Enum = "[E] ",
          EnumMember = "[e] ",
          Event = "[~] ",
          Field = "[.] ",
          File = "[F] ",
          Folder = "[D] ",
          Function = "[f] ",
          Interface = "[I] ",
          Key = "[k] ",
          Keyword = "[K] ",
          Method = "[m] ",
          Module = "[M] ",
          Namespace = "[N] ",
          Null = "[0] ",
          Number = "[#] ",
          Object = "[O] ",
          Operator = "[=] ",
          Package = "[P] ",
          Property = "[p] ",
          Reference = "[&] ",
          Snippet = "[S] ",
          String = '["] ',
          Struct = "[S] ",
          Supermaven = "[AI] ",
          TabNine = "[AI] ",
          Text = "[t] ",
          TypeParameter = "[T] ",
          Unit = "[U] ",
          Value = "[v] ",
          Variable = "[x] ",
        },
      },

      ---@type table<string, string[]|boolean>?
      kind_filter = {
        default = {
          "Class",
          "Constructor",
          "Enum",
          "Field",
          "Function",
          "Interface",
          "Method",
          "Module",
          "Namespace",
          "Package",
          "Property",
          "Struct",
          "Trait",
        },
        markdown = false,
        help = false,
        lua = {
          "Class",
          "Constructor",
          "Enum",
          "Field",
          "Function",
          "Interface",
          "Method",
          "Module",
          "Namespace",
          "Property",
          "Struct",
          "Trait",
        },
      },
    },
  },
  --
  -- {
  --   "akinsho/bufferline.nvim",
  --   opts = function(_, opts)
  --     opts.options = opts.options or {}
  --
  --     -- 1. Replace all hardcoded Nerd Font symbols with basic ASCII
  --     opts.options.buffer_close_icon = "x"
  --     opts.options.modified_icon = "*"
  --     opts.options.close_icon = "X"
  --     opts.options.left_trunc_marker = "<"
  --     opts.options.right_trunc_marker = ">"
  --     opts.options.indicator = { style = "none" } -- Removes the thick edge bar
  --
  --     -- 2. Prevent Bufferline from asking for filetype icons
  --     opts.options.show_buffer_icons = false
  --     opts.options.color_icons = false
  --
  --     -- 3. Replace Powerline slant/slope separators with a simple pipe character
  --     opts.options.separator_style = { "|", "|" }
  --
  --     return opts
  --   end,
  -- },

  -- {
  --   "saghen/blink.cmp",
  --   opts = {
  --
  --     appearance = {
  --       kind_icons = {
  --         Text = "Txt",
  --         Method = "Mth",
  --         Function = "Fn",
  --         Constructor = "Ctor",
  --
  --         Field = "Fld",
  --         Variable = "Var",
  --         Property = "Prp",
  --
  --         Class = "Cls",
  --         Interface = "Int",
  --         Struct = "Str",
  --         Module = "Mod",
  --
  --         Unit = "Unt",
  --         Value = "Val",
  --         Enum = "Enm",
  --         EnumMember = "EnM",
  --
  --         Keyword = "Kwd",
  --         Constant = "Cst",
  --
  --         Snippet = "Snp",
  --         Color = "Col",
  --         File = "Fil",
  --         Reference = "Ref",
  --         Folder = "Dir",
  --         Event = "Evt",
  --         Operator = "Op",
  --         TypeParameter = "TyP",
  --       },
  --     },
  --   },
  -- },

  -- 3. Blink.cmp (Autocomplete menu)
  -- {
  --   "saghen/blink.cmp",
  --   opts = function(_, opts)
  --     opts.appearance = opts.appearance or {}
  --     -- Replace completion icons with standard text abbreviations
  --     opts.appearance.kind_icons = {
  --       Text = "Txt",
  --       Method = "Mth",
  --       Function = "Fn",
  --       Constructor = "Ctor",
  --       Field = "Fld",
  --       Variable = "Var",
  --       Class = "Cls",
  --       Interface = "IF",
  --       Module = "Mod",
  --       Property = "Prp",
  --       Unit = "Unt",
  --       Value = "Val",
  --       Enum = "Enm",
  --       Keyword = "Kwd",
  --       Snippet = "Snp",
  --       Color = "Col",
  --       File = "Fil",
  --       Reference = "Ref",
  --       Folder = "Dir",
  --       EnumMember = "EnM",
  --       Constant = "Cst",
  --       Struct = "Str",
  --       Event = "Evt",
  --       Operator = "Op",
  --       TypeParameter = "TyP",
  --     }
  --   end,
  -- },

  -- 4. Trouble.nvim (Diagnostics panel)
  -- {
  --   "folke/trouble.nvim",
  --   opts = function(_, opts)
  --     opts.icons = false -- Version 3 natively supports disabling icons
  --   end,
  -- },

  -- 5. Which-Key (Keybind popups)
  -- {
  --   "folke/which-key.nvim",
  --   opts = function(_, opts)
  --     opts.icons = {
  --       breadcrumb = ">>",
  --       separator = "->",
  --       group = "+",
  --       mappings = false, -- Disables the new keycap/command icons in v3
  --       rules = false,
  --     }
  --   end,
  -- },

  -- 6. Noice.nvim (Command line and notifications)
  -- {
  --   "folke/noice.nvim",
  --   opts = function(_, opts)
  --     opts.format = opts.format or {}
  --     -- Replaces cmdline prompts with basic characters
  --     opts.cmdline = {
  --       format = {
  --         cmdline = { pattern = "^:", icon = ":", lang = "vim" },
  --         search_down = { kind = "search", pattern = "^/", icon = "/", lang = "regex" },
  --         search_up = { kind = "search", pattern = "^%?", icon = "?", lang = "regex" },
  --         filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
  --         lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "lua", lang = "lua" },
  --         help = { pattern = "^:%s*he?l?p?%s+", icon = "help" },
  --       },
  --     }
  --   end,
  -- },

  -- 7. Todo-Comments (Gutter highlight signs)
  -- {
  --   "folke/todo-comments.nvim",
  --   opts = function(_, opts)
  --     opts.signs = false -- Disables the graphical gutter signs entirely
  --   end,
  -- },

  -- 8. Render-Markdown.nvim (Markdown UI enhancements)
  -- {
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   opts = function(_, opts)
  --     opts.heading = opts.heading or {}
  --     opts.bullet = opts.bullet or {}
  --     opts.checkbox = opts.checkbox or {}
  --
  --     opts.heading.icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " }
  --     opts.bullet.icons = { "-", "*", "+" }
  --     opts.checkbox.unchecked = { icon = "[ ] " }
  --     opts.checkbox.checked = { icon = "[x] " }
  --     opts.sign = { enabled = false }
  --   end,
  -- },

  -- 9. Mason (LSP/Tool installer UI)
  -- {
  --   "williamboman/mason.nvim",
  --   opts = function(_, opts)
  --     opts.ui = opts.ui or {}
  --     opts.ui.icons = {
  --       package_installed = "Y",
  --       package_pending = "-",
  --       package_uninstalled = "N",
  --     }
  --   end,
  -- },

  -- 10. Neotest (Test runner UI)
  -- {
  --   "nvim-neotest/neotest",
  --   opts = function(_, opts)
  --     opts.icons = {
  --       passed = "Pass",
  --       running = "Run",
  --       failed = "Fail",
  --       skipped = "Skip",
  --       unknown = "?",
  --       non_collapsible = "",
  --       collapsed = "+",
  --       expanded = "-",
  --       child_prefix = "",
  --       child_indent = "",
  --       final_child_prefix = "",
  --       final_child_indent = "",
  --     }
  --   end,
  -- },

  -- 11. Snacks.nvim (Dashboard, Notifier, Picker)
  -- {
  --   "folke/snacks.nvim",
  --   opts = function(_, opts)
  --     if opts.notifier then
  --       opts.notifier.icons = { error = "E ", warn = "W ", info = "I ", debug = "D ", trace = "T " }
  --     end
  --     if opts.dashboard then
  --       -- Force a simple text header instead of ASCII art that might break in TTY
  --       opts.dashboard.preset = { header = "NEOVIM" }
  --     end
  --   end,
  -- },

  {
    "kristijanhusak/vim-dadbod-ui",
    init = function()
      vim.g.db_ui_use_nerd_fonts = 0
    end,
  },
}
