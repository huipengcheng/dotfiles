return {
  'kevinhwang91/nvim-ufo',
  dependencies = { 'kevinhwang91/promise-async' },
  event = 'BufReadPost',
  init = function()
    vim.o.foldcolumn = '0'
    vim.o.foldlevel = 99 -- ufo needs a large value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  keys = {
    { 'zR', function() require('ufo').openAllFolds() end, desc = 'UFO: Open all folds' },
    { 'zM', function() require('ufo').closeAllFolds() end, desc = 'UFO: Close all folds' },
    { 'zr', function() require('ufo').openFoldsExceptKinds() end, desc = 'UFO: Open folds except kinds' },
    { 'zm', function() require('ufo').closeFoldsWith() end, desc = 'UFO: Close folds with' },
    {
      'K',
      function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then vim.lsp.buf.hover() end
      end,
      desc = 'UFO: Peek fold / Hover',
    },
  },
  config = function()
    local handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (' 󰁂 %d '):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if curWidth + chunkWidth < targetWidth then suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth) end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      table.insert(newVirtText, { suffix, 'MoreMsg' })
      return newVirtText
    end

    require('ufo').setup {
      open_fold_hl_timeout = 150,
      close_fold_kinds_for_ft = {
        default = { 'imports', 'comment' },
        json = { 'array' },
        c = { 'comment', 'region' },
      },
      close_fold_current_line_for_ft = {
        default = true,
        c = false,
      },
      preview = {
        win_config = {
          border = { '', '─', '', '', '', '─', '', '' },
          winhighlight = 'Normal:Folded',
          winblend = 0,
        },
        mappings = {
          scrollU = '<C-u>',
          scrollD = '<C-d>',
          jumpTop = '[',
          jumpBot = ']',
        },
      },
      fold_virt_text_handler = handler,
      provider_selector = function(bufnr, filetype, buftype) return { 'treesitter', 'indent' } end,
    }
  end,
}
