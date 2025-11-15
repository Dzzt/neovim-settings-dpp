-- configuration for hadronized/hop.nvim
-- (substitution for easymotion)

local hop = require('hop')
hop.setup({})

-- hop.nvimのヒントの方向を定義
local directions = require('hop.hint').HintDirection

-- =========================================================================
-- 1. <Leader>f / <Leader>t 相当: 単一文字検索 (行内/行外)
-- -------------------------------------------------------------------------
-- <Leader>f: カーソル位置以降の単一文字へジャンプ (<Plug>(easymotion-bd-f) 相当)
vim.keymap.set('n', '<Leader>f', function()
  -- { direction = directions.AFTER_CURSOR } でカーソル以降を検索 (デフォルトで行を跨ぐ)
  hop.hint_char1({ direction = directions.AFTER_CURSOR })
end, {noremap = true})

-- <Leader>t: カーソル位置以降の単一文字の**手前**へジャンプ (<Plug>(easymotion-bd-f)のターゲット手前相当)
vim.keymap.set('n', '<Leader>t', function()
  -- hint_offset = -1 で選択した文字の直前の位置に移動
  hop.hint_char1({ direction = directions.AFTER_CURSOR, hint_offset = -1 })
end, {noremap = true})


-- =========================================================================
-- 2. <Leader><Leader>f / <Leader><Leader>t 相当: 複数文字検索 (2文字、行内/行外)
-- -------------------------------------------------------------------------
-- <Leader><Leader>f: カーソル位置以降の2文字へジャンプ (<Plug>(easymotion-bd-f2) 相当)
vim.keymap.set('n', '<Leader><Leader>f', function()
  -- hop.hint_char2 は2文字 (Target Word) 検索に使用
  hop.hint_char2({ direction = directions.AFTER_CURSOR })
end, {noremap = true})

-- <Leader><Leader>t: カーソル位置以降の2文字の**手前**へジャンプ (<Plug>(easymotion-bd-t2) 相当)
vim.keymap.set('n', '<Leader><Leader>t', function()
  -- hint_offset = -1 で選択した2文字の手前の位置に移動 (1文字目の手前)
  hop.hint_char2({ direction = directions.AFTER_CURSOR, hint_offset = -1 })
end, {noremap = true})

