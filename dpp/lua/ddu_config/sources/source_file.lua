-- configuration for ddu-source-file

local fn = vim.fn
local keymap = vim.keymap

-- file 起動（カレントパスセット）
keymap.set("n", "<space>f", function()
	fn["ddu#custom#patch_global"]({
		sourceOptions = {
			file = { path = fn.expand("%:p:h") },
		},
	})
	fn["ddu#start"]({ sources = { { name = "file" } } })
end, { silent = true })

-- filer 手動起動
keymap.set("n", "<space>e", function()
	fn["ddu#start"]({
		name = "filer",
		ui = "filer",
		sources = { { name = "file" } },
	})
end, { silent = true })
