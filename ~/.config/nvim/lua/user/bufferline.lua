-- lua/user/bufferline.lua
local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  vim.notify("Error al cargar bufferline: " .. tostring(bufferline), vim.log.levels.ERROR)
  return
end

bufferline.setup({
  options = {
    mode = "buffers", -- Puede ser "tabs" si prefieres gestionar pestañas de vim en lugar de buffers
    numbers = "none", -- "ordinal" o "buffer_id" o "both"
    close_command = "bdelete! %d", -- Comando para cerrar un buffer
    right_mouse_command = "bdelete! %d", -- Comando con click derecho
    left_mouse_command = "buffer %d",    -- Comando con click izquierdo
    middle_mouse_command = nil,          -- Comando con click medio
    indicator = {
        icon = '▎', -- Indicador del buffer actual
        style = 'icon', -- 'underline' o 'none'
    },
    buffer_selected_icon = "●", -- Icono para buffer seleccionado (necesita Nerd Font)
    -- buffer_visible_icon = "●",
    -- buffer_invisible_icon = "○",
    modified_icon = '✥', -- Icono para buffer modificado (necesita Nerd Font)
    close_icon = '', -- Icono para cerrar (necesita Nerd Font)
    left_trunc_marker = '', -- Marcador de truncado a la izquierda
    right_trunc_marker = '', -- Marcador de truncado a la derecha
    --max_name_length = 18,
    --max_prefix_length = 15, -- Oculta el prefijo si es más largo
    --tab_size = 18,
    diagnostics = "nvim_lsp", -- "nvim_lsp", "coc", false
    diagnostics_update_in_insert = false,
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local s = " "
      for e, n in pairs(diagnostics_dict) do
        local icon = e == "error" and "" or (e == "warning" and "" or "") -- Requiere Nerd Font
        s = s .. n .. icon .. " "
      end
      return s
    end,
    -- Para mostrar los iconos de nvim-web-devicons
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    persist_buffer_sort = true, -- Mantener el orden de los buffers
    -- Separadores
    separator_style = "thin", -- "thick", "thin", "slope", "padded_slope"
    enforce_regular_tabs = false,
    always_show_bufferline = true, -- Mostrar siempre la bufferline, incluso si solo hay un buffer
    --hover = {
    --    enabled = true,
    --    delay = 200,
    --    reveal = {'close'}
    --},
    offsets = {
      {
        filetype = "NvimTree",
        text = "Explorador de Archivos", -- Texto a mostrar cuando NvimTree está activo
        text_align = "left",
        separator = true
      }
    }
  },
  highlights = {
    -- Nota: estos colores son ejemplos, se verán mejor con un colorscheme consistente.
    -- Los dejaremos comentados para que el colorscheme que elijamos luego los maneje.
    -- fill = {
    --   bg = "#2E3440"
    -- },
    -- background = {
    --   bg = "#3B4252"
    -- },
  }
})

-- Mapeos para navegar entre buffers
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map('n', '<TAB>', ':BufferLineCycleNext<CR>', {desc = "Siguiente buffer", noremap = true, silent = true})
map('n', '<S-TAB>', ':BufferLineCyclePrev<CR>', {desc = "Buffer anterior", noremap = true, silent = true})

-- Cerrar buffer actual (usando <leader>x como ejemplo, el usuario puede cambiarlo)
-- <leader> es \ por defecto.
map('n', '<leader>w', ':bdelete<CR>', {desc = "Cerrar buffer actual", noremap = true, silent = true}) -- Cambiado de <leader>x a <leader>w (window close)
map('n', '<leader>W', ':bufdo bdelete<CR>', {desc = "Cerrar todos los buffers", noremap = true, silent = true})


-- Mapeos para ir a buffers específicos (ej. Alt + 1, Alt + 2, ...)
-- Estos pueden entrar en conflicto con atajos de terminal/SO. Usar con precaución o cambiar.
-- for i = 1, 9 do
--   map('n', string.format('<A-%d>', i), string.format(':BufferLineGoToBuffer %d<CR>', i), opts)
-- end

-- Mover buffers
map('n', '<leader>bp', ':BufferLineMovePrev<CR>', {desc = "Mover buffer a la izquierda", noremap = true, silent = true})
map('n', '<leader>bn', ':BufferLineMoveNext<CR>', {desc = "Mover buffer a la derecha", noremap = true, silent = true})

-- Ordenar buffers
map('n', '<leader>bs', ':BufferLineSortByDirectory<CR>', {desc = "Ordenar buffers por directorio", noremap = true, silent = true})
map('n', '<leader>bl', ':BufferLineSortByExtension<CR>', {desc = "Ordenar buffers por extensión", noremap = true, silent = true})

-- "Pin" buffer (mantenerlo a la izquierda)
map('n', '<leader>bt', ':BufferLineTogglePin<CR>', {desc = "Pin/Unpin buffer", noremap = true, silent = true})
