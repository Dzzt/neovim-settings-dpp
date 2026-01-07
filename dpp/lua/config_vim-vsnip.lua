-- configuration for vim-vsnip

local g = vim.g
local fn = vim.fn
local keymap = vim.keymap

--set snippet dir
g.vsnip_snippet_dir = fn.expand('~/.config/nvim/snippets')
g.vsnip_filetypes = vim.empty_dict()

-- <C-l>: スニペット展開、または次のプレースホルダーへ移動
keymap.set({ "i", "s" }, "<C-l>", function()
  if fn["vsnip#jumpable"](1) == 1 then
    return "<Plug>(vsnip-jump-next)"
  else
    return "<C-l>"
  end
end, { expr = true, remap = true })

-- <C-h>: 前のプレースホルダーへ移動
keymap.set({ "i", "s" }, "<C-h>", function()
  if fn["vsnip#jumpable"](-1) == 1 then
    return "<Plug>(vsnip-jump-prev)"
  else
    return "<C-h>"
  end
end, { expr = true, remap = true })
