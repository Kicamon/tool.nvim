local function preview()
  vim.fn.jobstart('typora "' .. vim.fn.expand("%") .. '"')
  vim.api.nvim_set_option_value('autoread', true, { buf = 0 })
end

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = '*.md',
  callback = function()
    vim.api.nvim_create_user_command('MarkdownPreview', preview, { nargs = 0 })
  end
})
