-- configuration for ddu.vim

local fn = vim.fn
local opt = vim.opt

-- 1. dpp のプラグインパス設定
-------------------------------------------------------------------------------
local ddu_repo_dir = fn.expand("~/.cache/dpp/repos/github.com")

local plugins = {
	"Shougo/ddu-ui-ff",
	"Shougo/ddu-ui-filer",
	"Shougo/ddu-filter-matcher_substring",
	"Shougo/ddu-filter-matcher_hidden",
	"Shougo/ddu-filter-sorter_alpha",
	"Shougo/ddu-column-file",
	"Shougo/ddu-kind-file",
	"Shougo/ddu-kind-word",
	"Shougo/ddu-source-file",
	"Shougo/ddu-source-register",
	"shun/ddu-source-buffer",
	"kuuote/ddu-source-mr",
}

for _, plugin in ipairs(plugins) do
	opt.runtimepath:append(ddu_repo_dir .. "/" .. plugin)
end

-- 2. 設定モジュールの読み込み
-------------------------------------------------------------------------------
-- UI設定
require("ddu_config.ui.ff")
require("ddu_config.ui.filer")

-- キーマッピング・autocmd
require("ddu_config.keymap")

-- 各 source 設定
local sources = {
	"kind_word",
	"kind_file",
	"source_buffer",
	"source_register",
	"source_file",
	"source_mr",
	"source_dpp",
}
for _, source in ipairs(sources) do
	require("ddu_config.sources." .. source)
end
