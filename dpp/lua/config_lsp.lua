local lsp = vim.lsp

local lspconfig = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')

-- use deno installed by Chocolatey(not by Mason for denols)
cmd = {'deno', 'lsp'}

-- Lsp servers
local lsp_servers = {
    "pyright",
    "lua_ls",
    "powershell_es",
    "csharp_ls",
    "vimls",
}

-- Setup mason_lspconfig here
mason_lspconfig.setup{
    ensure_installed = lsp_servers,
}

lsp.config("*",{})
lsp.enable(lsp_servers)
