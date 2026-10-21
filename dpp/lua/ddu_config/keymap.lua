-- keymap config for ddu.vim and it's extensions

local fn = vim.fn
local cmd = vim.cmd
local api = vim.api
local keymap = vim.keymap

-- UIアクション呼び出し用のヘルパー関数
local function do_action(name, params)
	return function()
		fn["ddu#ui#do_action"](name, params or vim.empty_dict({}))
	end
end

-- 1. キーバインド定義関数
local function setup_ff_keymaps()
	local opts = { buffer = true, silent = true }
	keymap.set("n", "<C-y>", do_action("itemAction"), opts)
	keymap.set("n", "<CR>", do_action("itemAction"), opts)
	keymap.set("n", "<Space>", do_action("toggleSelectItem"), opts)
	keymap.set("n", "i", do_action("openFilterWindow"), opts)
	keymap.set("n", "q", do_action("quit"), opts)
	keymap.set("n", "p", do_action("togglePreview"), opts)
end

local function setup_filter_keymaps()
	local opts = { buffer = true, silent = true }
	keymap.set("i", "<CR>", function()
		do_action("closeFilterWindow")()
		fn.win_gotoid(vim.g["ddu#ui#ff#_filter_parent_winid"])
	end, opts)
	keymap.set("n", "<CR>", do_action("closeFilterWindow"), opts)
	keymap.set("n", "q", do_action("closeFilterWindow"), opts)
end

local function setup_filer_keymaps()
	local opts = { buffer = true, silent = true }

	-- 1. Enter キー: ディレクトリなら展開/折りたたみ（トグル）、ファイルなら右ペインで開く
	keymap.set("n", "<CR>", function()
		local item = fn["ddu#ui#get_item"]()
		if not item then
			return
		end

		if item.isTree then
			-- UIアクションの expandItem に mode = "toggle" を渡すことで展開/折りたたみが自動切り替えされます
			fn["ddu#ui#do_action"]("expandItem", { mode = "toggle" })
		else
			-- ファイルの場合は右ペインで開く
			fn["ddu#ui#do_action"]("itemAction", {
				name = "open",
				params = { command = "wincmd p | edit" },
			})
		end
	end, opts)

	--2. 一つ上のフォルダに移動
	keymap.set("n", "u", function()
		-- 現在のファイラーが表示しているアイテム情報を取得
		local item = fn["ddu#ui#get_item"]()
		if not item then
			return
		end

		-- アイテムのパスまたは ddu のコンテキストから親ディレクトリのパスを取得
		local current_path = item.action and item.action.path or vim.fn.getcwd()
		local parent_path = fn.fnamemodify(current_path, ":h")

		-- 親ディレクトリを新しい root として filer を再起動/移動
		fn["ddu#start"]({
			name = "filer",
			ui = "filer",
			sources = {
				{
					name = "file",
					options = {
						path = parent_path,
					},
				},
			},
		})
	end, opts)

	-- 3. q キー: 終了
	keymap.set("n", "q", do_action("quit"), opts)
end

-- 2. Autocmd の登録
local ddu_group = api.nvim_create_augroup("UserDduConfig", { clear = true })

api.nvim_create_autocmd("FileType", {
	group = ddu_group,
	pattern = "ddu-ff",
	callback = setup_ff_keymaps,
})

api.nvim_create_autocmd("FileType", {
	group = ddu_group,
	pattern = "ddu-ff-filter",
	callback = setup_filter_keymaps,
})

api.nvim_create_autocmd("FileType", {
	group = ddu_group,
	pattern = "ddu-filer",
	callback = setup_filer_keymaps,
})

---- 起動時にディレクトリが指定された場合は filer を起動
--api.nvim_create_autocmd("VimEnter", {
--	group = ddu_group,
--	callback = function(data)
--		local directory = fn.isdirectory(data.file) == 1
--		if directory then
--			cmd.cd(data.file)
--
--			fn["ddu#start"]({
--				name = "filer",
--				ui = "filer",
--				sources = { { name = "file", params = {} } },
--			})
--		end
--	end,
--})
