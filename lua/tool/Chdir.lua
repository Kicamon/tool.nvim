local function chdir()
  vim.cmd('silent! lcd %:p:h')
  vim.notify(' :' .. vim.fn.expand('%:p:h'))
end

vim.api.nvim_create_user_command('Chdir', chdir, { nargs = 0 })
