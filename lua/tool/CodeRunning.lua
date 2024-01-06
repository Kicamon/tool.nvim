local feedkeys = function(keys, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), mode, true)
end

local function RunWin()
  local Win = require("tool.util.FloatWin")
  Win:Create({
    anchor = 'NE',
    width = 0.25,
    height = 0.86,
    title = ' Code Running '
  }, {
    buflisted = true,
    pos = 'tr',
  })
end

local function Run()
  vim.cmd('w')
  vim.cmd('Chdir')
  local filename = vim.fn.expand('%')
  local runfile = vim.fn.expand('%<')
  local filetype = vim.bo.filetype
  if filetype == 'c' then
    RunWin()
    if (vim.fn.filereadable('Makefile') == 1) then
      vim.cmd('term make && ./Main')
    else
      vim.cmd(string.format('term gcc "%s" -o "%s" && ./"%s" && rm -f "%s"', filename, runfile, runfile, runfile))
    end
  elseif filetype == 'cpp' then
    RunWin()
    if (vim.fn.filereadable('Makefile') == 1) then
      vim.cmd('term make && ./Main')
    else
      vim.cmd(string.format('term g++ "%s" -std=c++17 -O2 -g -Wall -o "%s" && ./"%s" && rm -rf "%s"',
        filename, runfile, runfile, runfile))
    end
  elseif filetype == 'python' then
    RunWin()
    vim.cmd(string.format('term python3 "%s"', filename))
  elseif filetype == 'lua' then
    RunWin()
    vim.cmd(string.format('term lua "%s"', filename))
  elseif filetype == 'markdown' then
    vim.cmd('MarkdownPreview')
  elseif filetype == 'sh' then
    RunWin()
    vim.cmd(string.format('term bash "%s"', filename))
  elseif filetype == 'html' then
    vim.cmd("tabe")
    vim.cmd("term live-server --browser=" .. vim.g.browser)
    vim.cmd("tabclose")
    feedkeys('<ESC>', 'n')
  end
end

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'c', 'cpp', 'python', 'lua', 'markdown', 'sh', 'html' },
  callback = function()
    vim.keymap.set('n', '<F5>', Run, {})
  end
})
