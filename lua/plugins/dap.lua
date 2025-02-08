-- lua/plugins/dap.lua
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Настройка адаптера для C/C++
      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
      }

      -- Конфигурация отладки
      dap.configurations.cpp = {
        {
          name = "Launch Debug",
          type = "cppdbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = true,
          setupCommands = {
            {
              text = "-enable-pretty-printing",
              description = "Enable pretty printing",
              ignoreFailures = false,
            },
          },
        },
      }

      -- Автоматическая сборка
      dap.listeners.before.event_initialized["make_build"] = function()
        vim.cmd("silent! make debug")
      end

      -- Настройка интерфейса
      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      -- Горячие клавиши
      vim.keymap.set("n", "<F5>", dap.continue)
      vim.keymap.set("n", "<F9>", dap.toggle_breakpoint)
      vim.keymap.set("n", "<F10>", dap.step_over)
    end,
  },
}
