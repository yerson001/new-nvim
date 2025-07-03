-- lua/user/options.lua
local opt = vim.opt -- para abreviar

-- Aquí pondremos las opciones generales de Neovim
opt.number = true -- Muestra números de línea
opt.relativenumber = true -- Muestra números de línea relativos
opt.autoindent = true -- Autoindentar
opt.smartindent = true -- Indentación inteligente
opt.expandtab = true -- Usar espacios en lugar de tabs
opt.shiftwidth = 2 -- Número de espacios para indentación
opt.tabstop = 2 -- Número de espacios que ocupa un tab
opt.softtabstop = 2
opt.wrap = false -- No hacer wrap de líneas largas

opt.ignorecase = true -- Ignorar mayúsculas/minúsculas al buscar, a menos que se use una mayúscula
opt.smartcase = true

opt.hlsearch = true -- Resaltar todas las coincidencias de búsqueda
opt.incsearch = true -- Muestra coincidencias mientras se escribe el patrón de búsqueda

opt.termguicolors = true -- Habilitar colores verdaderos en la terminal

opt.clipboard = "unnamedplus" -- Usar el portapapeles del sistema

-- Habilitar plugins de tipo de archivo, indentación y sintaxis
vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable") -- Asegurar que la sintaxis esté habilitada

-- Más opciones se pueden añadir aquí
