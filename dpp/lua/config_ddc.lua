-- configuration for ddc.vim

local fn = vim.fn

-- 1. 基本設定
-- 補完時のメッセージを抑制する 
vim.opt.shortmess:append("c")

-- 2. Global Patch (全体設定)
fn["ddc#custom#patch_global"]({

  -- UIにnativeを使用 
  ui = 'native',

  -- デフォルトソース 
  sources = { 'around', 'file' },

  sourceOptions = {
    ['_'] = {
      matchers = { 'matcher_head', 'matcher_length' },
      sorters = { 'sorter_rank' },
      -- 重複削除 
      converters = { 'converter_remove_overlap' },
    },

    around = { mark = 'A' }, 

    file = {
      mark = 'F',
      isVolatile = true,
      forceCompletionPattern = [[\S/\S*]], 
    },

    ['nvim-lsp'] = {
      mark = 'L',
      forceCompletionPattern = [[\.\w*|:\w*|->\w*]], 
    },

    vsnip = { mark = 'vsnip' }, 

  },

  sourceParams = {
    around = { maxSize = 500 }, 
    file = { smartCase = true }, 
  }

})

-- 3. Filetype 特有の設定 (choshoctl 用)
-- Luaの if 文で分岐させる代わりに ddc の機能でスマートに管理できます
fn["ddc#custom#patch_filetype"]('choshoctl', {
  sources = { 'vsnip' } 
})

-- 4. キーマッピング
local opts = { silent = true, expr = true, replace_keycodes = true }

-- TABで次の候補を選択、または手動補完を開始 
vim.keymap.set('i', '<TAB>', function()

  if fn.pumvisible() == 1 then
    return '<C-n>'
  end

  local col = fn.col('.')
  local line = fn.getline('.')

  if col <= 1 or line:sub(col - 1, col - 1):match('%s') then
    return '<TAB>'
  end

  return fn["ddc#map#manual_complete"]()

end, opts)

-- S-TABで一つ前の候補を選択 
vim.keymap.set('i', '<S-TAB>', function()
  return fn.pumvisible() == 1 and '<C-p>' or '<C-h>'
end, opts)

-- 5. ddcの有効化
fn["ddc#enable"]() 

