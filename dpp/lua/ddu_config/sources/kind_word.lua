-- configuration for ddu-kind-word

local fn = vim.fn

fn["ddu#custom#patch_global"]({
	kindOptions = {
		word = { defaultAction = "append" },
	},
	sources = {
		{ name = "word" },
	},
})
