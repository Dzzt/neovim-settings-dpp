-- configuration for ddu-ui-filer

local fn = vim.fn

fn["ddu#custom#patch_global"]({
	uiParams = {
		filer = {
			split = "vertical",
			winPosition = "left",
			winWidth = "40",
			splitDirection = "topleft",
			toggle = true,
		},
	},

	sourceOptions = {
		file = {
			sorters = { "sorter_alpha" },
			columns = { "filename" },
		},
	},

	columnOptions = {
		filename = {
			defaultAction = "open",
		},
	},

	columnParams = {
		filename = {
			indentation = "  ",
			collapsedIcon = "▸",
			expandedIcon = "▾",
			icon = " ",
		},
	},
})
