return {
  {
    "mbbill/undotree",
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        {
          {
            "<leader>b",
            group = "buffer",
            expand = function()
              local ret = {}
              local ok, bufferline = pcall(require, "bufferline")
              if not ok then
                return ret
              end

              -- This fetches the visible tabs exactly as they appear left-to-right
              local elements = bufferline.get_elements().elements

              for i, element in ipairs(elements) do
                if i <= 10 then
                  -- Map the 10th buffer to "0", otherwise use 1-9
                  local key = (i == 10) and "0" or tostring(i)

                  ret[#ret + 1] = {
                    key,
                    function()
                      bufferline.go_to(i, true)
                    end,
                    desc = element.name, -- Displays the actual filename in Which-Key
                  }
                end
              end

              return ret
            end,
          },
        },
      },
    },
  },
}
