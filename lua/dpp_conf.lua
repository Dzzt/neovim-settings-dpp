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

  -- 
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

-- create install command
api.nvim_create_user_command("DppInstall",
function()
    dpp.async_ext_action("installer", "install")
end,{})

-- create update command
api.nvim_create_user_command("DppUpdate",
function(opts)
	local args = opts.fargs
	dpp.async_ext_action("installer", "update", { names = args })
end, { nargs = "*" })

