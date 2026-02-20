-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- 还原光标位置
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    -- 获取上次离开时的位置标记 (")
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    
    -- 如果标记行号大于 0 且不大于当前文件总行数（防止文件被外部截断导致越界）
    if mark[1] > 0 and mark[1] <= lcount then
      -- 尝试跳转（使用 pcall 捕获可能发生的边缘错误）
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

