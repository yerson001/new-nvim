-- Configuración de nvim-tree
require'nvim-tree'.setup {
    -- Configuraciones específicas de nvim-tree
    view = {
        width = 30,
        side = 'left',
    },
    renderer = {
        icons = {
            glyphs = {
                default = "",
                symlink = "",
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★",
                    deleted = "",
                    ignored = "◌"
                },
                folder = {
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                },
            },
        },
    },
    actions = {
        open_file = {
            quit_on_open = false,
        },
    },
}
