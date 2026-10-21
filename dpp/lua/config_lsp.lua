local lsp = vim.lsp

-- Lsp servers
local lsp_servers = {
	"denols",
	"pylsp",
	"powershell_es",
	"vimls",
}

local external_servers = {
	"lua_ls",
}

-- Setup mason_lspconfig
require("mason-lspconfig").setup({
	ensure_installed = lsp_servers,
})

-- config servers
local server_configs = {
	pylsp = {
		settings = {
			pylsp = {
				plugins = {
					-- confortで設定
					black = { enabled = false },
					pycodestyle = { enabled = false },
					pyflakes = { enabled = false },
					mccabe = { enabled = false },
					autopep8 = { enabled = false },
					yapf = { enabled = false },
				},
			},
		},
	},

	lua_ls = {
		cmd = { "lua-language-server" },
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = {
					checkThirdParty = false,
					library = { vim.env.VIMRUNTIME },
				},
				telemetry = { enable = false },
			},
		},
	},
}

-- 個別に設定を適用して有効化
for _, server in ipairs(lsp_servers) do
	local config = server_configs[server] or {}
	lsp.config(server, config)
end

-- 外部管理サーバーの設定と有効化
for _, server in ipairs(external_servers) do
	local config = server_configs[server] or {}
	lsp.config(server, config)
end
lsp.enable(external_servers)

-- enable lsp
lsp.enable(lsp_servers)
