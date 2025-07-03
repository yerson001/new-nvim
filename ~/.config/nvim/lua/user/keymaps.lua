-- lua/user/keymaps.lua
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Aquí pondremos nuestros mapas de teclado personalizados

-- Ejemplo: Mapeo para salir del modo inserción más rápido
-- map("i", "jk", "<ESC>", opts)

-- Limpiar resaltado de búsqueda
map("n", "<leader><space>", ":nohlsearch<CR>", { desc = "Limpiar Resaltado Búsqueda", silent = true })

-- Navegación entre ventanas (splits)
map("n", "<C-h>", "<C-w>h", { desc = "Ventana Izquierda", noremap = true, silent = true })
map("n", "<C-j>", "<C-w>j", { desc = "Ventana Abajo", noremap = true, silent = true })
map("n", "<C-k>", "<C-w>k", { desc = "Ventana Arriba", noremap = true, silent = true })
map("n", "<C-l>", "<C-w>l", { desc = "Ventana Derecha", noremap = true, silent = true })

-- Mover líneas/selección con Alt + j/k
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Mover línea abajo", silent = true })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Mover línea arriba", silent = true })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Mover selección abajo", silent = true })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Mover selección arriba", silent = true })

-- Más mapeos se añadirán aquí
