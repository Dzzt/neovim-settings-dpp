--configuration for Mason
local mason = require('mason')

mason.setup({
    ui = {

        icons = {
           package_installed = "✓",
           package_pending = "➜",
           package_uninstalled = "✗"
        },

        keymaps = {
            filter = '<C-f>',
            toggle_help = 'g?'
        },

    },
})

