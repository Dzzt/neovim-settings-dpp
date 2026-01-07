local lsp = vim.lsp

-- default configuration
lsp.config("*",{})

-- Lsp servers
local lsp_servers = {
    "denols",
    "pylsp",
    "powershell_es",
    "vimls",
}

-- Setup mason_lspconfig here
require('mason-lspconfig').setup{
    ensure_installed = lsp_servers,
}

-- enable lsp servers
lsp.enable(lsp_servers)
