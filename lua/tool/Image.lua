local function feedkeys (keys, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), mode, true)
end

local function check()
  local has_image = vim.fn.system("xclip -selection clipboard -t TARGETS -o")
  if has_image == nil then
    return false
  end
  local val = string.find(has_image, "image/png")
  if val == nil then
    return false
  end
  return true
end

local function paste()
  local path = vim.fn.expand("%:p:~:h")
  path = path .. "/img/"
  if vim.fn.isdirectory(path) == 0 then
    vim.cmd("silent !mkdir -p" .. path)
  end
  if check() then
    local imagename = vim.fn.input("Enter image name: ")
    vim.fn.system("xclip -selection clipboard -t image/png -o > " .. path ..  imagename .. ".png")

    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_lines(0, row, row, true, { "![](./img/" .. imagename .. ".png)" })
    vim.api.nvim_win_set_cursor(0, { row + 1, 1 })
    feedkeys("a", "n")
  end
end

return {
  image_paste = paste
}
