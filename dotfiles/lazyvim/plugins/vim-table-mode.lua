return {
  "dhruvasagar/vim-table-mode",
  lazy = true,
  ft = "markdown",
  config = function()
    vim.keymap.del("v", "<leader>T")
    vim.keymap.del("v", "<leader>tt")
    vim.keymap.del("n", "<leader>tt")
    vim.keymap.del("n", "<leader>tm")

    vim.g.table_mode_disable_mappings = 1
    vim.g.table_mode_disable_tableize_mappings = 0
  end,
}
