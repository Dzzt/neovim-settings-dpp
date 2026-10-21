--specify chocolatey installed deno.exe

local g = vim.g
local fn = vim.fn
g["denops#deno"] = fn.expand("~/AppData/Local/Microsoft/WinGet/Links/deno.exe")
