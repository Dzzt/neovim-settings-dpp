-- config for confom.nvim

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
	},

	format_on_save = function(bufnr)
		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

		for _, line in ipairs(lines) do
			if line:match("^%s*import%s+arcpy%s*$") then
				-- ArcGIS / Python 2.7 用は自動整形しない
				return nil
			end
		end

		return {
			timeout_ms = 2000,
			lsp_fallback = true,
		}
	end,
})
