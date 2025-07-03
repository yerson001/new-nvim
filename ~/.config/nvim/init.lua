-- init.lua
-- Este archivo será el punto de entrada principal.
-- Por ahora, solo cargará nuestra configuración de plugins y opciones básicas.

-- Cargar configuraciones de usuario
require("user.options") -- Crearemos este archivo más tarde para opciones generales
require("user.keymaps") -- Crearemos este archivo más tarde para mapas de teclado
require("user.plugins") -- Aquí se gestionarán los plugins con Packer
require("user.colorscheme") -- Crearemos este archivo para el tema
-- Cargar configuraciones de plugins específicos (se crearán más adelante)
require("user.cmp")
require("user.lspconfig")
require("user.telescope")
require("user.nvim-tree")
require("user.bufferline")
-- require("user.toggleterm")
