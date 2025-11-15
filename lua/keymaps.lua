
local keymap = vim.keymap

--  ---------------------------------------------------------
--  Keymaps

-- Clear highlights
keymap.set('n','<C-L>',':nohl<CR><C-L>')

-- Go normal mode with ESC
keymap.set('t','<ESC>',[[<C-\><C-n>]])

--  terminal mode setting
--  start terminal in new tab
keymap.set('n','@t',[[:botright new<CR>:terminal<CR>i]])

--  End terminal with Ctrl+q
keymap.set('t','<C-q>',[[<C-\><C-n>:q<CR>]])
