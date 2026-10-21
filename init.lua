--  Begin init.lua for user

local fn = vim.fn
local cmd = vim.cmd
local g = vim.g
-- --------------------------------------------------

-- do not use XDG base directories

-- Making table of core Lua files (includes dpp setup)
local configs = {
	"runtimepaths",
	"options_base_before",
	"dpp_conf",
	"options_base_after",
	"options_appearance",
	"options_editting",
	"keymaps",
	"netrw",
	"terminal",
}

-- Load settings
for _, config in ipairs(configs) do
	require(config)
end

-- set python.exe dir

g.python_host_prog = "C:\\Program Files\\Python314\\python.exe"

--Switch on GUI or Console
if g.neovide then
	require("neovide_config")
else
	require("console_config")
end
