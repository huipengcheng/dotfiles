local active_theme = "doom-one"

local themes = {
	{ "folke/tokyonight.nvim", opts = { styles = { comments = { italic = false } } } },
	"ellisonleao/gruvbox.nvim",
	-- "NTBBloodbath/doom-one.nvim",
	"romgrk/doom-one.vim",
	"rebelot/kanagawa.nvim",
	"thesimonho/kanagawa-paper.nvim",
	"neanias/everforest-nvim",
	"bluz71/vim-moonfly-colors",
	"bluz71/vim-nightfly-colors",
	{ "catppuccin/nvim", name = "catppuccin" },
	"EdenEast/nightfox.nvim",
	"sainnhe/gruvbox-material",
	"fynnfluegge/monet.nvim",
	"pineapplegiant/spaceduck",
	"loctvl842/monokai-pro.nvim",
}

for i, theme in ipairs(themes) do
	themes[i] = type(theme) == "string" and { theme, priority = 1000 } or theme
	themes[i].priority = 1000
end

-- 监听 Neovim 的启动生命周期。
-- 当 lazy.nvim 把上面的高优先级主题全部加载进内存后，触发这个回调进行激活。
vim.api.nvim_create_autocmd("VimEnter", {
	desc = "Theme Callback: Activate colorscheme after plugins load",
	callback = function()
		pcall(vim.cmd.colorscheme, active_theme)
	end,
})

return themes
