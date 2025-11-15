
local opt = vim.opt

-- options for editting function
---------------------------------------------------

-- Editting

-- Hide buffer instead of closing in order to re-use
    opt.hidden = true

-- Search options
    opt.ignorecase = true
    opt.smartcase = true

-- Highlight parenthesis-like characters
    opt.showmatch = true

-- Allow backspace over autoindent,
-- line breakes and start of insert action
    opt.backspace = 'start,eol,indent'

-- Stop certain movements from always going to the
-- first character of a line.
    opt.startofline = false

-- share clipboard with os
    opt.clipboard:append{'unnamedplus'}

-- ---------------------------------------------------------
-- Indentation

-- Auto indent
    opt.autoindent = true
    opt.shiftwidth = 4
    opt.tabstop = 4
    opt.softtabstop = 4
    opt.expandtab = true

