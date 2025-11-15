-- config_open-browser.lua
-- (open-browser.vim の設定)

local keymap = vim.keymap

keymap.set('n', 'owb', '<Plug>(openbrowser-open)', { noremap = false, silent = true })
keymap.set('v', 'owb', '<Plug>(openbrowser-open)', { noremap = false, silent = true })
