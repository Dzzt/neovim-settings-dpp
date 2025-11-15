--  Begin init.lua for user

local fn = vim.fn
local opt = vim.opt
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
for _,config in ipairs(configs) do
    require(config)
end

--Switch on GUI or Console
if vim.g.neovide then

    require("neovide_config")

else

    require("console_config")

end



