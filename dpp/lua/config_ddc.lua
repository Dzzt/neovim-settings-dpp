-- configuration for ddc.vim

local fn = vim.fn
local opt = vim.opt
local keymap = vim.keymap

-- 1. 基本設定

-- 補完時のメッセージを抑制する
opt.shortmess:append("c")

-- ddc_source_lsp で lsp に capabilities を設定
vim.lsp.config("*", {
	options = {
		capabilities = require("ddc_source_lsp").make_client_capabilities(),
	},
})

-- 2. Global Patch (全体設定)
fn["ddc#custom#patch_global"]({

	-- UIにnativeを使用
	ui = "native",

	-- デフォルトソース
	-- around と file はどのタイプのファイルでも使う
	sources = { "around", "file" },

	-- source の オプション
	sourceOptions = {

		-- 共通の設定
		["_"] = {

			-- matcher_head :文字列の先頭からマッチさせる
			-- matcher_lenght: 入力文字数より短い文字列はマッチさせない
			matchers = { "matcher_head", "matcher_length" },

			-- matchのスコアでソート（by "word"）
			sorters = { "sorter_rank" },

			-- 重複削除
			converters = { "converter_remove_overlap" },

			-- 入力２文字目から補完
			minAutoCompleteLength = 2, -- default
		},

		-- 周りの文字列から候補を表示
		around = {
			mark = "around",
			minAutoCompleteLength = 3,
		},

		-- 同じディレクトリのファイル名から候補を表示
		file = {
			mark = "file",
			isVolatile = true,
			minAutoCompleteLength = 3,
			forceCompletionPattern = [[\S/\S*]],
			-- \S : 空白以外の任意の1文字
			-- 空白ではない文字の直後にスラッシュが入力された時にマッチ。
		},

		-- Language Server
		lsp = {
			mark = "lsp",
			isVolatile = true,
			minAutoCompleteLength = 2,
			forceCompletionPattern = [[\.\w*|:\w*|->\w*|\$\w*|#\w*]],
			-- \w 英数字やアンダースコア
			keywordPattern = "\\k+",
			-- \k vim のiskeywordにマッチする単語
		},

		-- Snippet
		vsnip = {
			mark = "vsnip",
			minAutoCompleteLength = 3,
		},
	},

	-- sourceごとのパラメータ
	sourceParams = {
		around = { maxSize = 500 },
		file = { smartCase = true },
		lsp = {
			snippetEngine = fn["denops#callback#register"](function(body)
				fn["vsnip#anonymous"](body)
			end),
			enableResolveItem = true,
			enableAdditionalTextExit = true,
			confirmBehavior = "replace",
		},
	},
})

-- 3. Filetype 特有の設定

-- choshoctl 用
fn["ddc#custom#patch_filetype"]("spectype", {
	sources = { "completion_alter" },

	sourceOptions = {
		completion_alter = {
			matcherKey = "abbr", -- abbr の値でマッチさせる
			sorters = { "sorter_head" }, -- abbr の先頭からマッチさせる
			minAutoCompleteLength = 3, -- 3文字以上入力したら候補を表示
		},
	},

	sourceParams = {
		completion_alter = {
			jsonPath = fn.expand("~/.config/nvim/snippets/spectype.json"), --jsonファイルのパス
		},
	},
})

-- lspを使う言語
fn["ddc#custom#patch_filetype"]({ "lua", "typescript", "ps1", "python", "vim", "go" }, {
	sources = { "lsp", "around", "vsnip" },
})

-- 4. キーマッピング

local opts = { silent = true, expr = true, replace_keycodes = true }

-- TABで次の候補を選択、または手動補完を開始
keymap.set("i", "<TAB>", function()
	if fn.pumvisible() == 1 then
		return "<C-n>"
	end

	local col = fn.col(".")
	local line = fn.getline(".")

	if col <= 1 or line:sub(col - 1, col - 1):match("%s") then
		return "<TAB>"
	end

	return fn["ddc#map#manual_complete"]()
end, opts)

-- S-TABで一つ前の候補を選択
keymap.set("i", "<S-TAB>", function()
	return fn.pumvisible() == 1 and "<C-p>" or "<C-h>"
end, opts)

-- 5. ddcの有効化
fn["ddc#enable"]()
