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
      
      dap.configurations.c = {
        {
          name = "Launch Debug (C)",
          type = "cppdbg",
          request = "launch",
          program = function()
            vim.cmd("silent! make debug")
            return vim.fn.getcwd() .. "/debug"
          end,

          cwd = "${workspaceFolder}",
          stopAtEntry = true, 
          args = {},
          environment = {},
          externalConsole = false,
          MIMode = "gdb",
          miDebuggerPath = "/usr/bin/gdb", -- Убедитесь, что путь к gdb корректен
          },
        }
      -- Конфигурация отладки
      dap.configurations.cpp = {
        {
          name = "Launch Debug",
          type = "cppdbg",
          request = "launch",
          program = function()
            -- Автоматически собираем и используем файл debug
            vim.cmd("silent! make debug")
            return vim.fn.getcwd() .. "/debug"
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = false, -- Не останавливаться на входе
          args = {},
          environment = {},
          externalConsole = false,
          MIMode = "gdb",
          miDebuggerPath = "/usr/bin/gdb", -- Убедитесь, что путь к gdb корректен
          setupCommands = {
            {
              text = "-enable-pretty-printing",
              description = "Enable pretty printing",
              ignoreFailures = false,
            },
            {
              text = "-gdb-set follow-fork-mode child",
              description = "Follow child process",
              ignoreFailures = false,
            },
          },
        },
      }

      -- Настройка интерфейса DAP UI
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.5 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
      })

      -- Виртуальный текст
      require("nvim-dap-virtual-text").setup()

      -- Автоматическое открытие/закрытие DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Горячие клавиши
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue Debugging" })
      vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
    end,
  },
}
