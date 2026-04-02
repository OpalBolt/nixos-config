-- make :W the same as :w
vim.api.nvim_create_user_command('W', 'w', { nargs = 0 })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'nix',
  command = 'setlocal shiftwidth=2 tabstop=2',
})

-- remove all trailing whitespace on save
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*' },
  callback = function()
    local save_cursor = vim.fn.getpos '.'
    pcall(function()
      vim.cmd [[%s/\s\+$//e]]
    end)
    vim.fn.setpos('.', save_cursor)
  end,
})
