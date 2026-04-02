return {
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    config = function()
      local dap = require("dap")

      local function get_args(config)
        local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
        config = vim.deepcopy(config)
        ---@cast args string[]
        config.args = function()
          local new_args = vim.fn.input("Run with args: ", table.concat(args, " "))
          return vim.split(vim.fn.expand(new_args), " ")
        end
        return config
      end

      vim.keymap.set("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "Breakpoint Condition" })
      vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dc", function() dap.continue() end, { desc = "Continue" })
      vim.keymap.set("n", "<leader>da", function() dap.continue({ before = get_args }) end, { desc = "Run with Args" })
      vim.keymap.set("n", "<leader>dC", function() dap.run_to_cursor() end, { desc = "Run to Cursor" })
      vim.keymap.set("n", "<leader>dg", function() dap.goto_() end, { desc = "Go to Line (No Execute)" })
      vim.keymap.set("n", "<leader>di", function() dap.step_into() end, { desc = "Step Into" })
      vim.keymap.set("n", "<leader>dj", function() dap.down() end, { desc = "Down" })
      vim.keymap.set("n", "<leader>dk", function() dap.up() end, { desc = "Up" })
      vim.keymap.set("n", "<leader>dl", function() dap.run_last() end, { desc = "Run Last" })
      vim.keymap.set("n", "<leader>do", function() dap.step_out() end, { desc = "Step Out" })
      vim.keymap.set("n", "<leader>dO", function() dap.step_over() end, { desc = "Step Over" })
      vim.keymap.set("n", "<leader>dp", function() dap.pause() end, { desc = "Pause" })
      vim.keymap.set("n", "<leader>dr", function() dap.repl.toggle() end, { desc = "Toggle REPL" })
      vim.keymap.set("n", "<leader>ds", function() dap.session() end, { desc = "Session" })
      vim.keymap.set("n", "<leader>dt", function() dap.terminate() end, { desc = "Terminate" })
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      require("dap-python").setup("python3")
    end,
  },
}
