
local opt = vim.opt
local cmd = vim.cmd

-- Settings only for Console version
--
    local guibackground = "dark"
    local guicolorscheme = "jellybeans"

    opt.termguicolors = true
    opt.background = guibackground
    cmd.colorscheme(guicolorscheme)

-- tranceparency of floating windows by ddu-ff
-- opt.pumblend=35
-- opt.winblend=10
    cmd.redraw()
