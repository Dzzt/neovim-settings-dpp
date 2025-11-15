
local opt = vim.opt

-- options for basic behavior(load before dein)
---------------------------------------------------

-- No swap
    opt.swapfile = false

-- Move Current Directory When Open a file
    opt.autochdir = true

-- Set 'filetype'
    opt.filetype = "on"
    opt.filetype.indent = "on"
    opt.filetype.plugin = "on"
    opt.syntax = "on"

