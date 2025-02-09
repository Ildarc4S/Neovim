return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
        transparent_mode = true,
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "akinsho/bufferline.nvim",
    },
    config = function()
      -- Настройка Lualine (статусная строка)
      require("lualine").setup({
        options = {
          theme = "gruvbox",
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      -- Настройка Bufferline (вкладки)
      require("bufferline").setup({
        options = {
          mode = "tabs",
          separator_style = "slant",
          always_show_bufferline = true,
          show_close_icon = false,
          color_icons = true,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left",
            },
          },
        },
      })
    end,
  },
{
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
        },
        renderer = {
          icons = {
            show = {
              git = true,
            },
          },
        },
      })

      -- Автоматическое закрытие NvimTree при закрытии последнего файла
      local function tab_win_closed(winnr)
        local api = require("nvim-tree.api")
        local tabnr = vim.api.nvim_win_get_tabpage(winnr)
        local bufnr = vim.api.nvim_win_get_buf(winnr)
        local buf_info = vim.fn.getbufinfo(bufnr)[1]
        local tab_wins = vim.tbl_filter(function(w) return w ~= winnr end, vim.api.nvim_tabpage_list_wins(tabnr))
        local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
        
        if buf_info.name:match(".*NvimTree_%d*") then
          if #tab_bufs == 1 then
            local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
            if last_buf_info.name:match(".*NvimTree_%d*") then
              vim.schedule(function()
                if #vim.api.nvim_list_wins() == 1 then
                  vim.cmd("quit")
                else
                  vim.api.nvim_win_close(tab_wins[1], true)
                end
              end)
            end
          end
        end
      end

      vim.api.nvim_create_autocmd("WinClosed", {
        callback = function()
          local winnr = tonumber(vim.fn.expand("<amatch>"))
          vim.schedule_wrap(tab_win_closed(winnr))
        end,
        nested = true
      })
    end,
  },
}
