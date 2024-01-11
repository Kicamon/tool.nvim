local function Chdir()
  local dir = vim.fn.getcwd()
  vim.cmd('silent! lcd %:p:h')
  vim.notify('\nFrom: ' .. dir .. '\n' ..
    'To: ' .. vim.fn.expand('%:p:h'),
    1000, { title = 'Change directory', icon = '' })
end

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  callback = function()
    vim.api.nvim_create_user_command('Chdir', Chdir, { nargs = 0 })
  end
})
