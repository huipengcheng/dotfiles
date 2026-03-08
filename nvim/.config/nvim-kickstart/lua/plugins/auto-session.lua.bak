return {
  'rmagatti/auto-session',
  config = function ()
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    require('auto-session').setup {
      auto_restore_enabled = true,
      allowed_dirs = { '~/dev/**' },
      post_restore_cmds = {
        function ()
        end
      }
    }
  end
}
