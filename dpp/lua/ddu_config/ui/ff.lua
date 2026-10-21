-- configuration for ddu-ui-ff

local fn = vim.fn

fn["ddu#custom#patch_global"]({
	ui = "ff",

	uiParams = {
		ff = {
			ignoreEmpty = true,
			split = "floating",
			autoResize = true,
			displaySourceName = "short",
			floatingBorder = "none",
			winWidth = math.floor(vim.o.columns / 2) + 20,
			winHeight = math.floor(vim.o.lines / 4),
			winCol = math.floor((vim.o.columns - (vim.o.columns * 0.7)) / 2),
			winRow = 3,
			maxDisplayItems = 20,

			previewFloating = true,
			previewSplit = "vertical",
			previewFloatingBorder = "single",
			previewHeight = math.floor(vim.o.lines / 3),
		},
	},

	sourceOptions = {
		_ = {
			matchers = { "matcher_substring", "matcher_hidden" },
		},
	},
})
