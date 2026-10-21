-- configuration for ddu-source-buffer

local fn = vim.fn
local keymap = vim.keymap

-- source & kind の個別設定
fn["ddu#custom#patch_global"]({
	kindOptions = {
		buffer = { defaultAction = "open" },
	},
	sources = {
		{ name = "buffer" },
	},
})

-- 起動キーマップ
keymap.set("n", "<space>b", function()
	fn["ddu#start"]({ sources = { { name = "buffer" } } })
end, { silent = true })
