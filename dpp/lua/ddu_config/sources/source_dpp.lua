-- configuration for ddu-source-dpp(list of loaded plugins)

local fn = vim.fn
local keymap = vim.keymap

fn["ddu#custom#patch_global"]({
	sources = {
		{ name = "dpp" },
	},
})

keymap.set("n", "<space>d", function()
	fn["ddu#start"]({ sources = { { name = "dpp" } } })
end, { silent = true })
