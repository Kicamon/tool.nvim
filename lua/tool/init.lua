local api = vim.api

require('tool.CursorWord')

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
    end, { silent = true })
    vim.keymap.set('n', '<F10>', function()
      require('tool.CodeRunning').running(true)
    end, { silent = true })
  end
})

--- Image Paste
api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = "*.md",
  callback = function()
    vim.keymap.set('n', '<leader>P', function()
      require('tool.Image').image_paste()
    end)
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
          require('tool.ImSwitch').Zh_Insert()
        end
      end
    })
    api.nvim_create_autocmd('TextChangedI', {
      callback = function()
        if (vim.bo.filetype == 'python' or vim.bo.filetype == 'sh') and vim.fn.line('.') == 1 then
          return
        end
        require('tool.ImSwitch').Zh_Text()
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
        require('tool.MdTableFormat').markdown_table_format_lines()
      end
    })

    --- Surround
    vim.keymap.set('v', 'S', function()
      require('tool.Surround').Add_Surround()
    end, { silent = true })
    vim.keymap.set('n', 'cs', function()
      require('tool.Surround').Change_Surround()
    end, { silent = true })

    --- TabToSpace
    vim.keymap.set('n', '<leader>ts', function()
      require('tool.TabToSpace').TabToSpace()
    end, { silent = true })

    --- Wildfire
    vim.keymap.set({ 'n', 'v' }, '<cr>', function()
      require('tool.Wildfire').Wildfire()
    end, { silent = true })

    --- Align
    vim.keymap.set('v', 'ga', function()
      require('tool.Align').align()
    end, { silent = true })
  end
})

api.nvim_create_autocmd({ 'VimEnter' }, {
  callback = function()
    --- Yazi
    local Yazi = require('tool.Yazi').Yazi
    vim.keymap.set('n', '<leader>ra', function() Yazi('edit') end, {})
    vim.keymap.set('n', '<leader>rh', function() Yazi('vsplit', 'left') end, {})
    vim.keymap.set('n', '<leader>rj', function() Yazi('split', 'down') end, {})
    vim.keymap.set('n', '<leader>rk', function() Yazi('split', 'up') end, {})
    vim.keymap.set('n', '<leader>rl', function() Yazi('vsplit', 'right') end, {})
    vim.api.nvim_create_user_command('Yazi', function() Yazi('edit') end, { nargs = 0 })

    --- Wiki
    vim.keymap.set('n', '<leader>ww', function()
      require('tool.Wiki').OpenWiki()
    end, {})
  end
})
