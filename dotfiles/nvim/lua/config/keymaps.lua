-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit out of insert mode" })
vim.keymap.set("v", "jk", "<ESC>", { desc = "Exit out of insert mode" })

vim.keymap.set("n", "n", "nzz", { desc = "Center search results" })
vim.keymap.set("n", "N", "Nzz", { desc = "Center search results" })

vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Visual line wraps up", expr = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Visual line wraps down", expr = true })

vim.keymap.set("n", "<leader>m", ":let @/=''<CR>", { desc = "Cancel search highlight" })

vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move selected text up" })
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move selected text down" })
