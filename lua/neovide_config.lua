local g = vim.g
local opt = vim.opt
local api = vim.api
local cmd = vim.cmd

if g.neovide then
	--trace legitimate procedure when quitting
	g.neovide_confirm_quit = true

	--disable Neovide's clipboard
	g.neovide_no_custom_clipboard = true

	--colorscheme for gui
	local guibackground = "light"
	local guicolorscheme = "iceberg"

	opt.background = guibackground
	cmd.colorscheme(guicolorscheme)

	--floating and popup
	opt.winblend = 20
	opt.pumblend = 20

	--for ddu-ff
	api.nvim_create_autocmd({ "FileType" }, {
		pattern = { "ddu-ff", "ddu-ff-filter" },
		callback = function()
			opt.winblend = 15
			opt.pumblend = 15
		end,
	})

	-- font
	---------------------------------------------
	-- opt.guifont = "Ricty Diminished Discord for Po:h11"
	-- opt.guifont = "HackGen35 Console NFJ:h11"
	-- opt.guifont = "UDEV Gothic 35NFLG:h11"
	-- opt.guifont = "Firge35Nerd Console:h09"
	opt.guifont = "Bizin Gothic NF:h10.5:#e-subpixelantialias"

	-- linespace
	opt.linespace = 2

	-- Configration for Neovide
	---------------------------------------------
	-- theme(light ,dark ,auto)
	g.neovide_theme = "auto"

	-- hide mouse cursor when typing
	g.neovide_hide_mouse_when_typing = true

	-- Remember Window Size
	g.neovide_remember_window_size = false

	-- window opacity
	g.neovide_opacity = 1
	g.neovide_show_border = false

	-- title bar(only for Windows 11 22000 and later)
	local function update_titlebar()
		local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
		if normal.bg then
			vim.g.neovide_title_background_color = string.format("#%06x", normal.bg)
		end
	end

	-- 初期設定
	update_titlebar()

	-- カラースキーム変更時に追従
	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = update_titlebar,
	})

	g.neovide_title_text_color = "grey"

	--activate profiler
	-- g.neovide_profile = true

	--set refresh rate(only when using --no-vsync)
	--g.neovide_refresh_rate = 60
	--g.neovide_refresh_rate_idle = 5

	-- scale
	g.neovide_scale_factor = 1.0

	-- padding
	g.neovide_padding_top = 0
	g.neovide_padding_bottom = 0
	g.neovide_padding_right = 0
	g.neovide_padding_left = 0

	--- set animation features off
	g.neovide_scroll_animation_length = 0
	g.neovide_cursor_animation_length = 0
	g.neovide_cursor_trail_size = 0
	g.neovide_cursor_vfx_mode = ""

	-- control IME ON/OFF
	g.neovide_input_ime = true
end
