-- configuration for vim-vsnip

local g = vim.g
local fn = vim.fn

--set snippet dir
g.vsnip_snippet_dir = fn.expand('~/.config/nvim/snippets')
g.vsnip_filetypes = vim.empty_dict()

