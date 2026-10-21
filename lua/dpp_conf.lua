--set runtimepaths

local fn = vim.fn
local opt = vim.opt
local api = vim.api
-----------------------------------------------------------------------------------

-- typescript to define how dpp.vim works
local dpp_config_ts = fn.expand("~/.config/nvim/dpp/dpp_config.ts")

-- dpp cache
local dpp_base = fn.expand("~/.cache/dpp")

--install folder from github
local cache_dir = dpp_base .. "/repos/github.com"

-- dpp.vim need to be added to the top of runtimpath
local dpp_src = cache_dir .. "/Shougo/dpp.vim"
opt.runtimepath:prepend(dpp_src)

-- require dpp.vim
local dpp = require("dpp")

-- path for denops.vim(not add to runtimepath here)
local denops_src = cache_dir .. "/vim-denops/denops.vim"

-- add path of dpp components at the tail of runtimepath
local ext_toml = cache_dir .. "/Shougo/dpp-ext-toml"
local ext_lazy = cache_dir .. "/Shougo/dpp-ext-lazy"
local ext_installer = cache_dir .. "/Shougo/dpp-ext-installer"
local ext_local = cache_dir .. "/Shougo/dpp-ext-local"
local ext_git = cache_dir .. "/Shougo/dpp-protocol-git"

opt.runtimepath:append(ext_toml)
opt.runtimepath:append(ext_git)
opt.runtimepath:append(ext_lazy)
opt.runtimepath:append(ext_local)
opt.runtimepath:append(ext_installer)

-- do after dpp.vim is loaded
if dpp.load_state(dpp_base) then
	-- add denops.vim to runtimepath here
	opt.runtimepath:prepend(denops_src)

	-- make state.vim and startup.vim
	api.nvim_create_autocmd("User", {
		pattern = "DenopsReady",
		callback = function()
			vim.notify("vim load_state is failed.")
			dpp.make_state(dpp_base, dpp_config_ts)
		end,
	})
end

-- tell whe make_state() ends
vim.api.nvim_create_autocmd("User", {
	pattern = "Dpp:makeStatePost",
	callback = function()
		vim.notify("dpp make_state() is done.")
	end,
})

opt.filetype = "on"
opt.syntax = "on"

-- create update command
api.nvim_create_user_command("DppUpdate", function(opts)
	local args = opts.fargs
	dpp.async_ext_action("installer", "update", { names = args })
end, { nargs = "*" })

-- show update logs
api.nvim_create_user_command("DppShowUpdateLogs", function()
	local logs = dpp.sync_ext_action("installer", "getUpdateLogs")

	if next(logs) == nil then
		print("No plugins updated.")
		return
	else
		print(logs[#logs - 1])
		print(logs[#logs])
	end
end, {})

---- create install command
--api.nvim_create_user_command("DppInstall", function(opts)
--	local args = opts.fargs
--	dpp.async_ext_action("installer", "install", { names = args })
--end, { nargs = "*" })
