-- configuration for ddu-kind-file

local fn = vim.fn

fn["ddu#custom#patch_global"]({
	kindOptions = {
		file = { defaultAction = "open" },
	},
	sources = {
		{ name = "file" },
	},
})
