local function GetNode()
  local node_cursor = require("nvim-treesitter.ts_utils").get_node_at_cursor()
  vim.notify(node_cursor:type())
end

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  callback = function()
    vim.keymap.set("n", "<leader>N", GetNode, {})
  end
})
