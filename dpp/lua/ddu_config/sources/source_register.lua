-- configuration for ddu-source-register(clipboard)

local fn = vim.fn
local keymap = vim.keymap

fn["ddu#custom#patch_global"]({
	kindOptions = {
		register = { defaultAction = "append" },
	},
	sources = {
		{ name = "register" },
	},
	sourceOptions = {
		register = {
			matchers = { "matcher_substring" },
		},
	},
})

keymap.set("n", "<space>r", function()
	fn["ddu#start"]({ sources = { { name = "register" } } })
end, { silent = true })
