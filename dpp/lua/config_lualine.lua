-- lualine_config.lua
require('lualine').setup {
    options = {
        -- theme = 'base16',
        -- theme = 'everforest',
        -- theme = 'gruvbox-material',
        -- theme = 'horizon',
        -- theme = 'iceberg_dark',
        -- theme = 'iceberg_light',
        -- theme = 'modus-vivendi',
        theme = 'nord',
        -- theme = 'papercolor_light',
        -- theme = 'seoul256',
        -- theme = 'palenight',
        -- theme = 'OceanicNext',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        icons_enabled = true,
        disabled_filetypes = {},
        always_divide_middle = true,
        colored = false,
    },

    sections = {

        lualine_a = {'mode'},

        lualine_b = {
            {'windows',
                mode = 1
            }
        },

        lualine_c = {
            {'filename',
                 path = 1,
                 file_status = true,
                 shorting_target = 40,
                 symbols = {
                     modified = ' [+]',
                     readonly = ' [RO]',
                     unnamed = 'Untitled',
                 }
            }
        },

        lualine_x = {'encoding','filetype','fileformat'},
        lualine_y = {'progress','searchcount'},
        lualine_z = {'location'}

    },

    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },

    tabline = {},
    extensions = {},

}

