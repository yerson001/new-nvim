-- lua/user/telescope.lua
local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  vim.notify("Error al cargar telescope: " .. tostring(telescope), vim.log.levels.ERROR)
  return
end

local actions = require "telescope.actions"
local builtin = require "telescope.builtin"

telescope.setup {
  defaults = {
    prompt_prefix = "  ", -- Icono de búsqueda (requiere Nerd Font)
    selection_caret = " ", -- Icono de cursor de selección (requiere Nerd Font)
    -- path_display = { "truncate" }, -- Cómo mostrar las rutas de los archivos
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default + actions.center, -- Abrir y centrar
        ["<C-s>"] = actions.select_split, -- Abrir en split horizontal
        ["<C-v>"] = actions.select_vertical_split, -- Abrir en split vertical
        ["<C-t>"] = actions.select_tab, -- Abrir en nueva pestaña
      },
      n = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default + actions.center,
        ["s"] = actions.select_split,
        ["v"] = actions.select_vertical_split,
        ["t"] = actions.select_tab,
      },
    },
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      flex = {
        flip_columns = 120,
      }
    },
    sorting_strategy = "ascending",
    scroll_strategy = "cycle",
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      previewer = true,
      hidden = true, -- Mostrar archivos ocultos
      find_command = {'rg', '--files', '--hidden', '--glob', '!.git/*'}, -- Usa rg si está disponible
    },
    live_grep = {
      theme = "dropdown",
      previewer = true,
    },
    buffers = {
      theme = "dropdown",
      previewer = true,
      sort_mru = true,
      ignore_current_buffer = true,
    },
    help_tags = {
      theme = "dropdown",
      previewer = true,
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- enable fuzzy finding when applicable
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
    -- Puedes añadir otras extensiones aquí, como 'media_files.nvim'
  },
}

-- Para cargar la extensión FZF (si se instala 'telescope-fzf-native.nvim' y 'make' está disponible)
local fzf_native_status_ok, _ = pcall(require, "telescope._extensions.fzf")
if fzf_native_status_ok then
  telescope.load_extension "fzf"
  vim.notify("Telescope FZF Native cargado.", vim.log.levels.INFO)
else
  vim.notify("Telescope FZF Native no encontrado. Usando sorter por defecto.", vim.log.levels.WARN)
end


-- Mapeos de teclado para Telescope
local map = vim.keymap.set

-- Buscar archivos en el proyecto
map('n', '<leader>ff', function() builtin.find_files() end, {desc = "Telescope Buscar Archivos", noremap = true, silent = true})
-- Buscar texto en el proyecto (Live Grep)
map('n', '<leader>fg', function() builtin.live_grep() end, {desc = "Telescope Live Grep", noremap = true, silent = true})
-- Buscar en buffers abiertos
map('n', '<leader>fb', function() builtin.buffers() end, {desc = "Telescope Buscar Buffers", noremap = true, silent = true})
-- Buscar tags de ayuda de Vim
map('n', '<leader>fh', function() builtin.help_tags() end, {desc = "Telescope Ayuda Tags", noremap = true, silent = true})
-- Buscar keymaps
map('n', '<leader>fk', function() builtin.keymaps() end, {desc = "Telescope Keymaps", noremap = true, silent = true})
-- Buscar comandos de vim
map('n', '<leader>fc', function() builtin.commands() end, {desc = "Telescope Comandos", noremap = true, silent = true})
-- Buscar historial de comandos
map('n', '<leader>f:', function() builtin.command_history() end, {desc = "Telescope Historial Comandos", noremap = true, silent = true})
-- Buscar archivos recientes
map('n', '<leader>fr', function() builtin.oldfiles() end, {desc = "Telescope Archivos Recientes", noremap = true, silent = true})

-- vim.notify("Telescope configurado", vim.log.levels.INFO) -- Notificación ya no necesaria aquí
