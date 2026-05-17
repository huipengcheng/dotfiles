return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'theHamsta/nvim-dap-virtual-text',
      'mfussenegger/nvim-dap-python',
      'leoluz/nvim-dap-go',
    },
    keys = {
      { '<F5>',  function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
      { '<F10>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
      { '<F11>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
      { '<F12>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
      { '<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
      {
        '<leader>B',
        function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end,
        desc = 'Debug: Set Breakpoint with Condition',
      },
      { '<leader>bc', function() require('dap').clear_breakpoints() end, desc = 'Debug: [C]lear all breakpoints' },
      { '<leader>du', function() require('dapui').toggle() end, desc = 'Debug: Toggle UI' },
      {
        '<leader>dq',
        function()
          require('dap').terminate()
          require('dapui').close()
        end,
        desc = 'Debug: [Q]uit session',
      },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('nvim-dap-virtual-text').setup()

      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      -- Change breakpoint icons
      vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
      local breakpoint_icons = vim.g.have_nerd_font
          and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
        or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
      for type, icon in pairs(breakpoint_icons) do
        local tp = 'Dap' .. type
        local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
        vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
      end

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- Python: uses debugpy installed via Mason
      local function get_python_path()
        local venv = os.getenv 'VIRTUAL_ENV'
        if venv then return venv .. '/bin/python' end
        return vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python'
      end
      require('dap-python').setup(get_python_path())

      -- Go: uses delve installed via Mason
      require('dap-go').setup {
        delve = {
          -- On Windows delve must be run attached or it crashes.
          detached = vim.fn.has 'win32' == 0,
        },
      }

      -- C / C++ / Rust: uses codelldb installed via Mason
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
          args = { '--port', '${port}' },
        },
      }

      dap.configurations.cpp = {
        {
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function() return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file') end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp
    end,
  },
}
