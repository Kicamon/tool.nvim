local function input_chars()
  local chars = vim.fn.input("Align chars: ")
  if chars == '\x1b' then
    return false
  end
  return chars
end

local function change_lines(sl, el, chars)
  while true do
    local lines = vim.api.nvim_buf_get_lines(0, sl - 1, el, true)
    local start_pos, max_pos = 0, 0
    local position = {}
    for i = 1, #lines, 1 do
      local pos = string.find(lines[i], chars, start_pos)
      table.insert(position, pos)
      if pos ~= nil then
        max_pos = math.max(max_pos, pos)
      end
    end
    start_pos = max_pos + 1
    if #position <= 1 then
      return
    end
    for i = 1, #lines, 1 do
      if position[i] ~= nil then
         
      end
    end
  end
end

local function align()
  local chars = input_chars()
  if not chars then
    return
  end
  local getsurround = require('tool.util.GetSurround')
  local sl, _, el, _ = getsurround.Visual()
end
