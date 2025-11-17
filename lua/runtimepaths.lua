
local opt = vim.opt
local fn = vim.fn

-- runtimepaths
------------------------------------------------------------------

-- Neovim Home Directory
Neovim_Dir = fn.expand('~/.config/nvim')

--  append to runtimepath
opt.runtimepath:append(Neovim_Dir)
opt.runtimepath:append(Neovim_Dir .. [[/autoload]])
opt.runtimepath:append(Neovim_Dir .. [[/ftdetect]])
opt.runtimepath:append(Neovim_Dir .. [[/ftplugin]])
opt.runtimepath:append(Neovim_Dir .. [[/after/ftplugin]])
opt.runtimepath:append(Neovim_Dir .. [[/after/ftdetect]])
opt.runtimepath:append(Neovim_Dir .. [[/dict]])
opt.runtimepath:append(Neovim_Dir .. [[/colors]])
opt.runtimepath:append(Neovim_Dir .. [[/lua]])

Dpp_Dir = Neovim_Dir .. [[/dpp]]
opt.runtimepath:append(Dpp_Dir)
opt.runtimepath:append(Dpp_Dir .. [[/lua]])
opt.runtimepath:append(Dpp_Dir .. [[/toml]])

-- to avoid a plugin(actually mason.vim) to make state file under ~/.cache/nvim
local old_stdpath = fn.stdpath

fn.stdpath = function(value)

    if value == "cache" then
        return fn.expand("~/.cache/dpp")
    end

    return old_stdpath(value)
end
