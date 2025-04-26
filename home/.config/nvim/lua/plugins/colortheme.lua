return {
	{ -- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is.
		--
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		"folke/tokyonight.nvim",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("tokyonight").setup({
				styles = {
					comments = { italic = false }, -- Disable italics in comments
				},
			})

			-- Load the colorscheme here.
			-- Like many other themes, this one has different styles, and you could load
			-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
			-- vim.cmd.colorscheme("tokyonight")
		end,
	},

	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = true,
	},
	{
		"NTBBloodbath/doom-one.nvim",
		config = function()
			vim.cmd.colorscheme("doom-one")
		end,
	},
	{
		"romgrk/doom-one.vim",
		config = function()
			-- vim.cmd.colorscheme("doom-one")
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		config = function()
			-- vim.cmd.colorscheme("kanagawa")
		end,
	},
	{
		"thesimonho/kanagawa-paper.nvim",
		config = function()
			-- vim.cmd.colorscheme("kanagawa-paper")
		end,
	},
	{
		"neanias/everforest-nvim",
	},
	{
		"bluz71/vim-moonfly-colors",
		config = function()
			-- vim.cmd.colorscheme("moonfly")
		end,
	},
	{
		"bluz71/vim-nightfly-colors",
		config = function()
			-- vim.cmd.colorscheme("nightfly")
		end,
	},
	{
		"catppuccin/nvim",
		config = function()
			-- latte, frappe, macchiato, mocha
			-- vim.cmd.colorscheme("catppuccin-macchiato")
		end,
	},
	{
		"EdenEast/nightfox.nvim",
		config = function()
			-- nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox
			-- vim.cmd.colorscheme("terafox")
		end,
	},
	{
		"sainnhe/gruvbox-material",
		config = function()
			-- vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{
		"fynnfluegge/monet.nvim",
		config = function()
			-- vim.cmd.colorscheme("monet")
		end,
	},
	{
		"pineapplegiant/spaceduck",
		config = function()
			-- vim.cmd.colorscheme("spaceduck")
		end,
	},
	{
		"loctvl842/monokai-pro.nvim",
		config = function()
			-- vim.cmd.colorscheme("monokai-pro")
		end,
	},
}
