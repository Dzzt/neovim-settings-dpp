-- configuration for ddu-source-mr(external)

local fn = vim.fn
local keymap = vim.keymap

fn["ddu#custom#patch_global"]({
	kindOptions = {
		mr = { defaultAction = "open" },
	},
	sources = {
		{ name = "mr" },
	},
})

keymap.set("n", "<space>w", function()
	fn["ddu#start"]({ sources = { { name = "mr" } } })
end, { silent = true })

keymap.set("n", "<space>h", function()
	fn["ddu#start"]({
		sources = {
			{
				name = "mr",
				params = { kind = "mrw" },
			},
		},
	})
end, { silent = true })
