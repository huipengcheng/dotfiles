local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  if msg:find("watch.watch") or msg:find("ENOENT") or msg:find("Device not configured") then
    return
  end
  original_notify(msg, level, opts)
end
