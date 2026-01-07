local fn = vim.fn
local opt = vim.opt
local api = vim.api
-----------------------------------------------------------------------------------

-- dpp 動作設定の typescript
local dpp_config_ts = fn.expand("~/.config/nvim/dpp/dpp_config.ts")

-- dppのcache
local dpp_base = fn.expand("~/.cache/dpp")

--github からのインストール先
local cache_dir = dpp_base .. "/repos/github.com"

-- dpp.vim はruntimepath の最初に追加しなければならない
local dpp_src = cache_dir .. "/Shougo/dpp.vim"
opt.runtimepath:prepend(dpp_src)

-- dpp.vim を require
local dpp = require("dpp")

-- denops.vim はここでは runtimepath には追加しない
local denops_src = cache_dir .. "/vim-denops/denops.vim"

-- dpp コンポーネントのパスをruntimepathの最後に追加
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


-- dpp.vim がロードされていたら
if dpp.load_state(dpp_base) then

  -- denops.vim を runtimepath に追加
  opt.runtimepath:prepend(denops_src)

  -- stateを作成する
  api.nvim_create_autocmd("User", {
	pattern = "DenopsReady",
  	callback = function ()
		vim.notify("vim load_state is failed.")
  		dpp.make_state(dpp_base, dpp_config_ts)
  	end
  })
end

-- これはなくても大丈夫です。
vim.api.nvim_create_autocmd("User", {
	pattern = "Dpp:makeStatePost",
	callback = function ()
		vim.notify("dpp make_state() is done.")
	end
})

opt.filetype = "on"
opt.syntax = "on"


-- create update command
api.nvim_create_user_command("DppUpdate",
function(opts)
	local args = opts.fargs
	dpp.async_ext_action("installer", "update", { names = args })
end, { nargs = "*" })


-- これは手で打ってもいいかな？
---- create install command
--api.nvim_create_user_command("DppInstall",
--function()
--    dpp.async_ext_action("installer", "install")
--end,{})


-- show update logs
 api.nvim_create_user_command("DppShowUpdateLogs",
 function()
 
     local logs = dpp.sync_ext_action("installer", "getUpdateLogs")
 
     if next(logs) == nil then
         print("No plugins updated.")
         return
     else
         print(logs[#logs-1])
         print(logs[#logs])
     end
 
 end, {})
 
-- 上ので足りるので
-- list updated plugins
-- api.nvim_create_user_command("DppShowUpdatedPlugins",
-- function()
-- 
--     local updated_plugins = dpp.sync_ext_action("installer", "getUpdated")
-- 
--     if next(updated_plugins) == nil then
--         print("No plugins updated.")
--         return
--     else
--         print(string.format("Updated plugins:\n\n"))
-- 
--         for _,plugin in ipairs(updated_plugins) do
-- 
--             local string_result = string.format(
--                     "  %s\n  %s\n\n"
--                     ,plugin["repo"]
--                     ,plugin["url"]
--                 )
-- 
--             print(string_result)
-- 
--         end
--     end
-- 
-- end, {})

