return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    branch = 'master', -- master fixes https://github.com/nvim-telescope/telescope.nvim/issues/3439#issuecomment-2810701584
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    keys = {
      { '<leader>sh', function() require('telescope.builtin').help_tags() end, desc = 'Telescope: [S]earch [H]elp' },
      { '<leader>sk', function() require('telescope.builtin').keymaps() end, desc = 'Telescope: [S]earch [K]eymaps' },
      { '<leader>sf', function() require('telescope.builtin').find_files() end, desc = 'Telescope: [S]earch [F]iles' },
      { '<leader>ss', function() require('telescope.builtin').builtin() end, desc = 'Telescope: [S]earch [S]elect Telescope' },
      { '<leader>sw', function() require('telescope.builtin').grep_string() end, mode = { 'n', 'v' }, desc = 'Telescope: [S]earch current [W]ord' },
      { '<leader>sg', function() require('telescope.builtin').live_grep() end, desc = 'Telescope: [S]earch by [G]rep' },
      { '<leader>sd', function() require('telescope.builtin').diagnostics() end, desc = 'Telescope: [S]earch [D]iagnostics' },
      { '<leader>sr', function() require('telescope.builtin').resume() end, desc = 'Telescope: [S]earch [R]esume' },
      { '<leader>s.', function() require('telescope.builtin').oldfiles() end, desc = 'Telescope: [S]earch Recent Files' },
      { '<leader>sc', function() require('telescope.builtin').commands() end, desc = 'Telescope: [S]earch [C]ommands' },
      { '<leader><leader>', function() require('telescope.builtin').buffers() end, desc = 'Telescope: [ ] Find existing buffers' },
      { '<leader>gc', function() require('telescope.builtin').git_commits() end, desc = 'Telescope: Git commits' },
      { '<leader>gs', function() require('telescope.builtin').git_status() end, desc = 'Telescope: Git status' },
      {
        '<leader>/',
        function()
          require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end,
        desc = 'Telescope: [/] Fuzzily search in current buffer',
      },
      {
        '<leader>s/',
        function()
          require('telescope.builtin').live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        desc = 'Telescope: [S]earch [/] in Open Files',
      },
      {
        '<leader>sn',
        function() require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' } end,
        desc = 'Telescope: [S]earch [N]eovim files',
      },
    },
    config = function()
      local actions = require 'telescope.actions'
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-c>'] = actions.close,
              ['<C-u>'] = actions.preview_scrolling_up,
              ['<C-d>'] = actions.preview_scrolling_down,
            },
            n = {
              ['q'] = actions.close,
              ['v'] = actions.file_vsplit,
              ['s'] = actions.file_split,
              ['t'] = actions.file_tab,
              ['p'] = require('telescope.actions.layout').toggle_preview,
            },
          },
          hidden = true,
          file_ignore_patterns = {
            'node_modules',
            '.git/',
            'dist/',
            'build/',
            '%.lock',
            '%.min.js',
          },
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
          },
          path_display = { 'filename_first' },
          layout_strategy = 'vertical',
          sorting_strategy = 'ascending',
          layout_config = {
            height = 0.7,
            prompt_position = 'top',
            vertical = {
              mirror = true,
            },
          },
        },
        pickers = {
          find_files = { hidden = true },
          live_grep = { additional_args = { '--hidden' } },
          buffers = {
            sort_lastused = true,
            mappings = { i = { ['<C-d>'] = 'delete_buffer' } },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
    end,
  },
}
