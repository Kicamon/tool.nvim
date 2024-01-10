local function Chdir()
  local dir = vim.fn.getcwd()
  vim.cmd('silent! lcd %:p:h')
  vim.notify(
    'From ' .. dir .. '\n' ..
    vim.fn.expand('%:p:h')
  )
end

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  callback = function()
    vim.api.nvim_create_user_command('Chdir', Chdir, { nargs = 0 })
  end
})
