-- configuration for ddu.vim


local fn = vim.fn
local keymap = vim.keymap

-- 1. runtimepath の動的設定 (dpp のパス解決)
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
  vim.opt.runtimepath:append(ddu_repo_dir .. "/" .. plugin)
end

-- 2. Global Patch (UI, Kind, Sources)
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
-- Lua関数として定義し、後続の autocmd から呼び出します
_G.ddu_ff_settings = function()
  local opts = { buffer = true, silent = true }
  vim.keymap.set('n', '<C-y>', "<Cmd>call ddu#ui#do_action('itemAction')<CR>", opts)
  vim.keymap.set('n', '<CR>', "<Cmd>call ddu#ui#do_action('itemAction')<CR>", opts)
  vim.keymap.set('n', '<Space>', "<Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>", opts)
  vim.keymap.set('n', 'i', "<Cmd>call ddu#ui#do_action('openFilterWindow')<CR>", opts)
  vim.keymap.set('n', 'q', "<Cmd>call ddu#ui#do_action('quit')<CR>", opts)
end

_G.ddu_filter_settings = function()
  local opts = { buffer = true, silent = true }
  -- フィルターウィンドウでの設定
  vim.keymap.set('i', '<CR>', function()
    fn["ddu#ui#do_action"]("closeFilterWindow")
    fn.win_gotoid(vim.g["ddu#ui#ff#_filter_parent_winid"])
  end, opts)
  
  vim.keymap.set('n', '<CR>', "<Esc><Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>", opts)
  vim.keymap.set('n', 'q', "<Esc><Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>", opts)
end

-- 4. Autocmd の設定
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

-- 個別起動用のキーマップもここに集約
local keymap = vim.keymap
local fn = vim.fn

keymap.set('n','<space>w',"<Cmd>call ddu#start(#{sources: [#{ name: 'mr' }]})<CR>",{ silent = true })
keymap.set('n','<space>h',"<Cmd>call ddu#start(#{sources: [#{ name: 'mr', params:#{ kind: 'mrw' } }]})<CR>",{ silent = true })
keymap.set('n','<space>b',"<Cmd>call ddu#start(#{sources: [#{ name: 'buffer' }]})<CR>",{ silent = true })
keymap.set('n','<space>r',"<Cmd>call ddu#start(#{sources: [#{ name: 'register' }]})<CR>",{ silent = true })
keymap.set('n','<space>d',"<Cmd>call ddu#start(#{sources: [#{ name: 'dpp' }]})<CR>",{ silent = true })

-- File source 特有のパス解決を含むマッピング
keymap.set('n','<space>f', function()
    fn["ddu#custom#patch_global"]({
        sourceOptions = {
            file = { path = fn.expand('%:p:h') }
        }
    })
    fn["ddu#start"]({ sources = {{ name = 'file' }} })
end, { silent = true })
