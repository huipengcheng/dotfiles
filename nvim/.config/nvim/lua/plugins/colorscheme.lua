local active_theme = 'doom-one'

local themes = {
  { 'folke/tokyonight.nvim', opts = { styles = { comments = { italic = false } } } },
  'ellisonleao/gruvbox.nvim',
  'romgrk/doom-one.vim',
  'rebelot/kanagawa.nvim',
  'thesimonho/kanagawa-paper.nvim',
  'neanias/everforest-nvim',
  'bluz71/vim-moonfly-colors',
  'bluz71/vim-nightfly-colors',
  { 'catppuccin/nvim', name = 'catppuccin' },
  'EdenEast/nightfox.nvim',
  'sainnhe/gruvbox-material',
  'fynnfluegge/monet.nvim',
  'pineapplegiant/spaceduck',
  'loctvl842/monokai-pro.nvim',
}

-- Strip "user/" prefix and trailing ".nvim"/".vim" to get the colorscheme name.
local function repo_to_name(repo)
  return (repo:match '([^/]+)$'):gsub('%.nvim$', ''):gsub('%.vim$', '')
end

for i, theme in ipairs(themes) do
  local spec = type(theme) == 'string' and { theme } or theme
  local name = spec.name or repo_to_name(spec[1])
  if name == active_theme then
    spec.lazy = false
    spec.priority = 1000
    spec.config = function() vim.cmd.colorscheme(active_theme) end
  else
    spec.lazy = true
  end
  themes[i] = spec
end

return themes
