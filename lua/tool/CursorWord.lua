local function matchdelete(word)
  if word then
    vim.w.cursorword = nil
  end
  if vim.w.cursorword_match_id then
    vim.fn.matchdelete(vim.w.cursorword_match_id)
    vim.w.cursorword_match_id = nil
  end
end

local function matchstr(...)
  local ok, str = pcall(vim.fn.matchstr, ...)
  return ok and str or ''
end

local function matchadd()
  local coln = vim.fn.col('.')
  local line = vim.fn.getline('.')
  local left = matchstr(line:sub(1, coln), [[\k*$]])
  local right = matchstr(line:sub(coln), [[^\k*]]):sub(2)

  local cursorword = left .. right

  if cursorword == vim.w.cursorword then
    return
  end

  vim.w.cursorword = cursorword

  matchdelete()

  if #cursorword < 1 or #cursorword > 50 or cursorword:find('[\192-\255]+') then
    return
  end
  cursorword = vim.fn.escape(cursorword, [[~"\.^$[]*]])
  vim.w.cursorword_match_id = vim.fn.matchadd('CursorWord', [[\<]] .. cursorword .. [[\>]], -1)
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'python', 'lua', 'markdown', 'sh', 'html' },
  callback = function()
    local group_id = vim.api.nvim_create_augroup('CursorWord', { clear = true })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      group = group_id,
      callback = matchadd,
    })
    vim.api.nvim_create_autocmd('WinLeave', {
      group = group_id,
      callback = function()
        matchdelete(true)
      end
    })
  end
})
