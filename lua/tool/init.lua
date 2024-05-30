local api = vim.api
local tools = {
  'CursorWord',
  'CursorMove',
}

for _, v in ipairs(tools) do
  require('tool.' .. v)
end

local function ele_in_table(ele, tab)
  for _, v in ipairs(tab) do
    if v == ele then
      return true
    end
  end
  return false
end

--- CodeRunning
api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'c', 'cpp', 'python', 'lua', 'markdown', 'sh', 'html' },
  callback = function()
    vim.keymap.set('n', '<F5>', function()
      require('tool.CodeRunning').running(false)
    end)
    vim.api.nvim_create_user_command('Running', function()
      require('tool.CodeRunning').running(true)
    end, { nargs = 0 })
  end
})

api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  callback = function()
    --- Chdir
    vim.api.nvim_create_user_command('Chdir', function()
      require('tool.Chdir').Chdir()
    end, { nargs = 0 })
    --- ImSwitch
    api.nvim_create_autocmd('InsertLeave', {
      callback = function()
        require('tool.ImSwitch').En()
      end
    })
    api.nvim_create_autocmd('InsertEnter', {
      callback = function()
        local buf_info = vim.fn.expand('%:e')
        if ele_in_table(buf_info, { 'md', 'txt' }) then
          if require('tool.ImSwitch').filetype_checke() then
            require('tool.ImSwitch').Zh()
          end
        else
          local current_pos = vim.fn.getcurpos()
          current_pos[3] = current_pos[3] - 1
          vim.fn.setpos('.', current_pos)
          local ts_utils = require('nvim-treesitter.ts_utils')
          local previous_node = ts_utils.get_node_at_cursor()

          if previous_node and (previous_node:type() == 'comment' or previous_node:type() == 'comment_content') then
            require('tool.ImSwitch').Zh()
          end
        end
      end
    })
    api.nvim_create_autocmd('TextChangedI', {
      callback = function()
        if (vim.bo.filetype == 'python' or vim.bo.filetype == 'sh') and vim.fn.line('.') == 1 then
          return
        end
        local current_pos = vim.fn.getcurpos()
        current_pos[3] = current_pos[3] - 1
        vim.fn.setpos('.', current_pos)
        local ts_utils = require('nvim-treesitter.ts_utils')
        local previous_node = ts_utils.get_node_at_cursor()
        if previous_node and (previous_node:type() == 'comment' or previous_node:type() == 'comment_content') then
          require('tool.ImSwitch').Zh()
        end
        current_pos[3] = current_pos[3] + 1
        vim.fn.setpos('.', current_pos)
      end
    })
    --- GetNode
    vim.keymap.set('n', '<leader>N', function()
      require('tool.GetNode').GetNode()
    end, {})
    ---  QuickSubstitute
    vim.keymap.set({ 'n', 'v' }, '<leader>ss', function()
      require('tool.QuickSubstitute').QuickSubstitute()
    end, {})
    --- MdTableFormat
    api.nvim_create_autocmd('InsertLeave', {
      pattern = "*.md",
      callback = function()
        require('tool.MdTableFormat').markdown_table_format()
      end
    })
    api.nvim_create_autocmd('TextChangedI', {
      pattern = "*.md",
      callback = function()
        local current_line = vim.api.nvim_get_current_line()
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local char = current_line:sub(cursor_pos[2], cursor_pos[2])
        if char == '|' then
          require('tool.MdTableFormat').markdown_table_format()
          local length = #vim.api.nvim_get_current_line()
          vim.api.nvim_win_set_cursor(0, { cursor_pos[1], length })
        end
      end
    })
  end
})

api.nvim_create_autocmd({ 'VimEnter' }, {
  callback = function()
    --- Ranger
    local Ranger = require('tool.Ranger').Ranger
    vim.keymap.set('n', '<leader>ra', function() Ranger('edit') end, {})
    vim.keymap.set('n', '<leader>rh', function() Ranger('vsplit', 'left') end, {})
    vim.keymap.set('n', '<leader>rj', function() Ranger('split', 'down') end, {})
    vim.keymap.set('n', '<leader>rk', function() Ranger('split', 'up') end, {})
    vim.keymap.set('n', '<leader>rl', function() Ranger('vsplit', 'right') end, {})
    vim.api.nvim_create_user_command('Ranger', function() Ranger('edit') end, { nargs = 0 })
    --- Wiki
    vim.keymap.set('n', '<leader>ww', function()
      require('tool.Wiki').OpenWiki()
    end, {})
    --- Align
    vim.keymap.set('v', 'ga', function ()
      require('tool.Align').align()
    end, { silent = true })
  end
})

--- Surround
api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  callback = function()
    vim.keymap.set('v', 'S', function()
      require('tool.Surround').Add_Surround()
    end, {})
    vim.keymap.set('n', 'cs', function()
      require('tool.Surround').Change_Surround()
    end
    , {})
  end
})

--- TabToSpace
api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  callback = function()
    vim.keymap.set('n', '<leader>ts', function()
      require('tool.TabToSpace').TabToSpace()
    end, {})
  end
})

--- Wildfire
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  callback = function()
    vim.keymap.set({ 'n', 'v' }, '<cr>', function()
      require('tool.Wildfire').Wildfire()
    end, {})
  end
})
