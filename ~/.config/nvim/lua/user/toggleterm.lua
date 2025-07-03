-- lua/user/toggleterm.lua
local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  vim.notify("Error al cargar toggleterm: " .. tostring(toggleterm), vim.log.levels.ERROR)
  return
end

toggleterm.setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 15 -- Altura para terminales horizontales (inferior/superior)
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4 -- Ancho para terminales verticales
    end
    -- Para 'float', el tamaño se puede controlar mejor en la definición del terminal específico
  end,
  open_mapping = [[<c-\>]], -- Ctrl + \ para una terminal flotante por defecto (se puede sobreescribir)
  hide_numbers = true, -- Ocultar números de línea en la terminal
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 1, -- '1' es más oscuro, '2' más claro. Ajustar al gusto. '0' para deshabilitar.
  start_in_insert = true,
  insert_mappings = true, -- Permite mapeos en modo inserción dentro de la terminal
  persist_size = true,
  direction = 'float', -- Dirección por defecto para ToggleTerm cmd
  close_on_exit = true, -- Cerrar la ventana de la terminal cuando el proceso termine
  shell = vim.o.shell, -- Usar el shell por defecto del sistema
  float_opts = {
    border = 'curved', -- 'single', 'double', 'shadow', 'curved'
    winblend = 0, -- Para opacidad, requiere 'termguicolors'
    highlights = {
      border = "Normal", -- Usar colores del tema para el borde
      background = "Normal", -- Usar colores del tema para el fondo
    }
  },
  -- winbar = { -- experimental
  --   enabled = false,
  --   name_formatter = function(term)
  --     return term.name
  --   end
  -- },
})

-- Función para establecer mapeos de teclas dentro de la terminal
function _G.set_terminal_keymaps()
  local opts = {noremap = true, silent = true}
  -- Salir del modo terminal y volver a Normal en Neovim
  -- <esc> es problemático si se usa en la shell (ej. para cancelar comandos)
  -- Usaremos <C-space> como alternativa para salir del modo terminal.
  vim.api.nvim_buf_set_keymap(0, 't', '<C-Space>', [[<C-\><C-n>]], opts)

  -- Navegación entre ventanas desde la terminal (si es necesario, a veces interfiere)
  -- vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  -- vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  -- vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  -- vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

-- Aplicar los mapeos a todas las terminales de toggleterm
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

local Terminal = require('toggleterm.terminal').Terminal

-- Terminal inferior (como en VSCode)
-- Se abrirá con <leader>t (por defecto \t)
local bottom_term = Terminal:new({
    -- cmd = "bash", -- O tu shell preferido
    direction = 'horizontal',
    count = 10, -- ID único para esta terminal
    hidden = true, -- Para que no se abra al inicio
    size = 10, -- Altura en líneas
    on_open = function(term)
        vim.cmd("startinsert!")
    end,
    on_close = function(term)
        -- Puedes añadir acciones al cerrar si es necesario
    end,
})

function _BOTTOM_TERM_TOGGLE()
    bottom_term:toggle()
end
vim.keymap.set('n', '<leader>t', '<cmd>lua _BOTTOM_TERM_TOGGLE()<CR>', {noremap = true, silent = true, desc = "Toggle terminal inferior"})


-- Terminal flotante (ejemplo: para lazygit)
-- Se abrirá con <leader>gg
local lazygit_term = Terminal:new({
  cmd = "lazygit",
  hidden = true,
  direction = "float",
  count = 11, -- ID único
  float_opts = {
    border = "double",
  },
  on_open = function(term)
    vim.cmd("startinsert!")
    -- Mapeo específico para cerrar esta terminal flotante con 'q' o Ctrl+g
    vim.api.nvim_buf_set_keymap(term.bufnr, "t", "q", "<cmd>close<CR>", {noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-g>", "<cmd>close<CR>", {noremap = true, silent = true})
  end,
})

function _LAZYGIT_TOGGLE()
  lazygit_term:toggle()
end
vim.keymap.set('n', '<leader>gg', '<cmd>lua _LAZYGIT_TOGGLE()<CR>', {noremap = true, silent = true, desc = "Toggle LazyGit"})

-- Terminal flotante genérica (con Ctrl+\)
-- Esta es la que se abre por defecto con open_mapping = [[<c-\>]] si no se define una específica
-- Podemos redefinirla o crear una nueva
local float_term = Terminal:new({
    count = 1,
    direction = "float",
    hidden = true,
    on_open = function(term) vim.cmd("startinsert!") end,
})

function _FLOAT_TERM_TOGGLE()
    float_term:toggle()
end
-- Si quieres un mapeo diferente para la flotante genérica, por ejemplo <leader>ft
vim.keymap.set('n', '<leader>ft', '<cmd>lua _FLOAT_TERM_TOGGLE()<CR>', {noremap = true, silent = true, desc = "Toggle terminal flotante"})
-- El mapeo <c-\> seguirá funcionando para una terminal flotante genérica debido a `open_mapping` en setup.

-- Puedes añadir más definiciones de terminales aquí (vertical, en nueva pestaña, etc.)
-- Ejemplo: Terminal vertical a la derecha con <leader>vt
local vertical_term = Terminal:new({
    direction = 'vertical',
    count = 12,
    hidden = true,
    size = function(term) return vim.o.columns * 0.3 end, -- 30% del ancho
    on_open = function(term) vim.cmd("startinsert!") end,
})
function _VERTICAL_TERM_TOGGLE()
    vertical_term:toggle()
end
vim.keymap.set('n', '<leader>vt', '<cmd>lua _VERTICAL_TERM_TOGGLE()<CR>', {noremap = true, silent = true, desc = "Toggle terminal vertical"})


-- vim.notify("Toggleterm configurado y listo.", vim.log.levels.INFO)
-- No es necesario notificar aquí ya que la config se carga desde plugins.lua
-- Si hay un error al requerir 'toggleterm', el pcall lo notificará.
