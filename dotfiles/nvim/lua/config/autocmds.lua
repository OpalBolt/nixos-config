-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- make :W the same as :w
vim.api.nvim_create_user_command("W", "w", { nargs = 0 })

-- make :E the same as :e
vim.api.nvim_create_user_command("E", "e", { nargs = 0 })

-- remove all trailing whitespace on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
   pattern = { "*" },
   callback = function()
      local save_cursor = vim.fn.getpos(".")
      pcall(function()
         vim.cmd([[%s/\s\+$//e]])
      end)
      vim.fn.setpos(".", save_cursor)
   end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
   pattern = "kanagawa",
   callback = function()
      if vim.o.background == "light" then
         vim.fn.system("kitty +kitten themes Kanagawa_light")
      elseif vim.o.background == "dark" then
         vim.fn.system("kitty +kitten themes Kanagawa_dragon")
      else
         vim.fn.system("kitty +kitten themes Kanagawa")
      end
   end,
})

vim.api.nvim_create_autocmd("FileType", {
   pattern = "nix",
   command = "setlocal shiftwidth=2 tabstop=2",
})
