-- configuration for ddc.vim

local fn = vim.fn


-- 1. 基本設定

-- 補完時のメッセージを抑制する 
vim.opt.shortmess:append("c")

-- ddc_source_lsp で lsp に capabilities を設定
vim.lsp.config("*", {
    options = {
        capabilities = require('ddc_source_lsp').make_client_capabilities(),
    }
})


-- 2. Global Patch (全体設定)
fn["ddc#custom#patch_global"]({

  -- UIにnativeを使用 
  ui = 'native',

  -- デフォルトソース 
  -- around と file はどのタイプのファイルでも使う
  sources = { 'around', 'file' },

  -- source の オプション
  sourceOptions = {

    -- 共通の設定
    ['_'] = {
      matchers = { 'matcher_head', 'matcher_length' },
      sorters = { 'sorter_rank' },
      -- 重複削除 
      converters = { 'converter_remove_overlap' },
      minAutoCompleteLength = 2, -- default
    },

    -- 周りの文字列から表示
    around = { 
      mark = 'around',
      minAutoCompleteLength = 3,
    }, 

    -- 同じディレクトリのファイル
    file = {
      mark = 'file',
      isVolatile = true,
      minAutoCompleteLength = 3,
      forceCompletionPattern = [[\S/\S*]], 
    },

    -- Language Server 
    lsp = {
      mark = 'lsp',
      isVolatile = true,
      minAutoCompleteLength = 2,
      forceCompletionPattern =[[\.\w*|:\w*|->\w*|\$\w*|#\w*]], 
      keywordPattern = '\\k+',
    },

    -- Snippet
    vsnip = {
        mark = 'vsnip',
        minAutoCompleteLength = 3,
        }, 

  },

  -- sourceごとのパラメータ
  sourceParams = {
    around = { maxSize = 500 }, 
    file = { smartCase = true }, 
    lsp = {
        snippetEngine = fn["denops#callback#register"](
            function(body)
                fn["vsnip#anonymous"](body)
            end
        ),
        enableResolveItem = true,
        enableAdditionalTextExit = true,
        confirmBehavior = 'replace',
    }
  }

})



-- 3. Filetype 特有の設定

-- choshoctl 用
fn["ddc#custom#patch_filetype"]('choshoctl', {

  sources = { 'vsnip' },

  sourceOptions = {
      vsnip = {
        minAutoCompleteLength = 1,
      },
    },

})

-- それ以外のlspを使う言語
fn["ddc#custom#patch_filetype"]({'lua','typescript','ps1','python','vim','go'}, {
  sources = { 'lsp', 'around','vsnip' } 
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

