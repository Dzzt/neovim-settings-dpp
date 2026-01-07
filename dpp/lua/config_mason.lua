--configuration for Mason
local mason = require('mason')

mason.setup({
    ui = {

        install_root_dir = vim.fn.expand('~/.config/mason'),

        icons = {
           package_installed = "✓",
           package_pending = "➜",
           package_uninstalled = "✗"
        },

        keymaps = {
            filter = '<C-f>',
            toggle_help = 'g?',
        },
    },
})

