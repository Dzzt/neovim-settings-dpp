-- configuration for ddu.vim

local fn = vim.fn
local opt = vim.opt
local keymap = vim.keymap

-- 1. runtimepath の動的設定 (dpp のパス解決)
-------------------------------------------------------------------------------

local ddu_repo_dir = fn.expand("~/.cache/dpp/repos/github.com")

local plugins = {
  "Shougo/ddu-ui-ff",
  "Shougo/ddu-kind-file",
  "Shougo/ddu-kind-word",
  "Shougo/ddu-filter-matcher_substring",
  "Shougo/ddu-filter-matcher_hidden",
  "Shougo/ddu-source-file",
  "Shougo/ddu-source-register",
  "shun/ddu-source-buffer",
  "kuuote/ddu-source-mr",
}

for _, plugin in ipairs(plugins) do
  opt.runtimepath:append(ddu_repo_dir .. "/" .. plugin)
end


-- 2. Global Patch (UI, Kind, Sources)
-------------------------------------------------------------------------------

fn["ddu#custom#patch_global"]({

  ui = 'ff',

  uiParams = {
    ff = {
      ignoreEmpty = true,
      split = 'floating',
      autoResize = true,
      displaySourceName = 'short',
      floatingBorder = 'none',
      winWidth = vim.o.columns / 2 + 20,
      winHeight = 20,
      winCol = 20,
      winRow = vim.o.lines / 3,
      maxDisplayItems = 10,
    },
  },

  kindOptions = {
    mr = { defaultAction = 'open' },
    register = { defaultAction = 'open' },
    buffer = { defaultAction = 'open' },
    file = { defaultAction = 'open' },
    word = { defaultAction = 'append' },
  },

  sources = {
    { name = 'mr' },
    { name = 'register' },
    { name = 'buffer' },
    { name = 'file' },
    { name = 'word' },
    { name = 'dpp' },
  },

  sourceOptions = {
    _ = {
      matchers = { 'matcher_substring', 'matcher_hidden' },
    },
  },

})


-- 3. キーマッピング用の関数定義 (FileType autocmd 用)
-------------------------------------------------------------------------------

-- UIアクションを呼び出すためのヘルパー関数
local function do_action(name, params)
  return function()
    fn["ddu#ui#do_action"](name, params or vim.empty_dict{})
  end
end

_G.ddu_ff_settings = function()
  local opts = { buffer = true, silent = true }
  
-- アクション名だけで定義できる
  keymap.set('n', '<C-y>',   do_action('itemAction'),       opts) 
  keymap.set('n', '<CR>',    do_action('itemAction'),       opts) 
  keymap.set('n', '<Space>', do_action('toggleSelectItem'), opts) 
  keymap.set('n', 'i',       do_action('openFilterWindow'), opts) 
  keymap.set('n', 'q',       do_action('quit'),             opts) 
end

-- フィルター用の設定
_G.ddu_filter_settings = function()

  local opts = { buffer = true, silent = true }

  -- フィルターウィンドウを閉じて親ウィンドウに戻るキー
  keymap.set('i', '<CR>', function()
    do_action("closeFilterWindow")
    fn.win_gotoid(vim.g["ddu#ui#ff#_filter_parent_winid"])
  end, opts)

  keymap.set('n', '<CR>', do_action('closeFilterWindow'), opts)
  keymap.set('n', 'q',    do_action('closeFilterWindow'), opts)
end


-- 4. Autocmd の設定
-------------------------------------------------------------------------------
local ddu_group = vim.api.nvim_create_augroup("UserDduConfig", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = ddu_group,
  pattern = "ddu-ff",
  callback = function() _G.ddu_ff_settings() end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = ddu_group,
  pattern = "ddu-ff-filter",
  callback = function() _G.ddu_filter_settings() end,
})

-- 5. 各source用の起動用キーマップ
-------------------------------------------------------------------------------

-- アクションを呼び出すためのヘルパー関数

local function ddu_start(source_spec)
  return function()
    fn["ddu#start"]({ sources = { source_spec } })
  end
end

-- buffer
keymap.set('n', '<space>b', ddu_start({ name = 'buffer' }), { silent = true })

-- register
keymap.set('n', '<space>r', ddu_start({ name = 'register' }), { silent = true })

-- file (set current path)
keymap.set('n','<space>f', function()
    fn["ddu#custom#patch_global"]({
        sourceOptions = {
            file = { path = fn.expand('%:p:h') }
        }
    })
    fn["ddu#start"]({ sources = {{ name = 'file' }} })
end, { silent = true })

-- dpp(loaded plugins)
keymap.set('n', '<space>d', ddu_start({ name = 'dpp' }), { silent = true })

-- mr
keymap.set('n', '<space>w', ddu_start({ name = 'mr' }), { silent = true })

-- mr for only written files
keymap.set('n', '<space>h', ddu_start({ 
  name = 'mr', 
  params = { kind = 'mrw' } 
}), { silent = true })



