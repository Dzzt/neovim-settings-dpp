-- configuration for vim-vsnip

local api = vim.api
local cmd = vim.cmd

local gitgraph = require("gitgraph")

gitgraph.setup({
	hooks = {
		-- コミット上で <Enter> を押した時に diffview で差分を表示する
		on_select_commit = function(commit)
			cmd(":DiffviewOpen " .. commit.hash .. "^!")
		end,
		-- コミット上で <S-Enter> (Shift+Enter) などを押した時に2つのコミット間差分を取るなどの拡張も可能
		on_select_range_commit = function(from, to)
			cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
		end,
	},
})
api.nvim_create_user_command("GitGraph", function()
	cmd("topleft vsplit | enew")
	gitgraph.draw({}, { all = true, max_count = 500 })
end, {})
