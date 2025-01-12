-- Función para cambiar entre temas
local function set_colorscheme(scheme)
    vim.cmd('colorscheme ' .. scheme)
end

-- Hacer la función global para que esté disponible en el autocomando
_G.set_colorscheme = set_colorscheme
