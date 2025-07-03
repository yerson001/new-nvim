-- lua/user/nvim-tree.lua
local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  vim.notify("Error al cargar nvim-tree: " .. tostring(nvim_tree), vim.log.levels.ERROR)
  return
end

-- Desactivar netrw por defecto si nvim-tree está cargado
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- Mapeos por defecto recomendados, puedes personalizarlos
  api.config.mappings.default_on_attach(bufnr)

  -- Mapeos personalizados
  -- vim.keymap.set('n', '<C-e>', api.tree.toggle, opts('Toggle')) -- Toggle con Ctrl-e (ejemplo, ya definido globalmente abajo)
  vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
end

nvim_tree.setup({
  sort_by = "name",
  -- Deshabilitar netrw completamente
  disable_netrw = true,
  hijack_netrw = true,
  -- Ignorar .git, node_modules, .cache
  filters = {
    dotfiles = false, -- Mostrar dotfiles
    custom = { ".git", "node_modules", ".cache" },
    exclude = {},
  },
  view = {
    width = 30,
    side = "left",
    -- Conservar el tamaño de la ventana de nvim-tree
    preserve_window_proportions = false,
    -- Iconos (requiere nvim-web-devicons)
    signcolumn = "yes", -- O "auto"
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  git = {
    enable = true,
    ignore = false, -- No ignorar archivos listados en .gitignore
    timeout = 400,
  },
  actions = {
    open_file = {
      quit_on_open = false, -- Dejar nvim-tree abierto después de abrir un archivo
      resize_window = true, -- Redimensionar la ventana principal si es necesario
    },
  },
  -- Llamar a on_attach para configurar los mapeos de teclas
  on_attach = on_attach,
  -- Otras opciones...
  update_focused_file = {
    enable = true,
    update_cwd = true, -- Cambia el CWD de Neovim al directorio del archivo enfocado
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
})

-- Atajo para abrir/cerrar nvim-tree
local map = vim.keymap.set
local opts_global = { noremap = true, silent = true }

-- Usaremos <leader>n para NvimTreeToggle como un estándar más común
-- El líder por defecto es '\', así que sería \n
-- El usuario puede remapear <leader> a otra tecla si lo desea
map("n", "<leader>n", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree", noremap = true, silent = true })
map("n", "<leader>e", ":NvimTreeFocus<CR>", { desc = "Focus NvimTree", noremap = true, silent = true })

-- Si el usuario prefiere Ctrl+N, puede descomentar esto y comentar el anterior
-- map("n", "<C-n>", ":NvimTreeToggle<CR>", opts_global)
-- Y asegurarse de que no haya conflictos con otros mapeos de Ctrl+N
