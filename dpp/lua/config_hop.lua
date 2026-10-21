-- configuration for smoka/hop.nvim

local hop = require("hop")
hop.setup({})

local directions = require("hop.hint").HintDirection

vim.keymap.set("n", "<Leader>f", function()
	--hop.hint_char1({ direction = directions.AFTER_CURSOR })
	hop.hint_char1({})
end, { noremap = true })

vim.keymap.set("n", "<Leader>t", function()
	hop.hint_char1({ hint_offset = -1 })
end, { noremap = true })

vim.keymap.set("n", "<Leader><Leader>f", function()
	hop.hint_char2({})
end, { noremap = true })

vim.keymap.set("n", "<Leader><Leader>t", function()
	hop.hint_char2({ hint_offset = -1 })
end, { noremap = true })
