-- lua/user/colorscheme.lua

-- Cargar el tema tokyonight
local status_ok, tokyonight = pcall(require, "tokyonight")
if not status_ok then
  vim.notify("Error al cargar el tema tokyonight: " .. tostring(tokyonight), vim.log.levels.WARN)
  -- Intentar cargar un tema por defecto si tokyonight falla
  local default_status_ok, _ = pcall(vim.cmd, "colorscheme habamax") -- habamax es un tema oscuro decente que viene con nvim > 0.8
  if not default_status_ok then
      pcall(vim.cmd, "colorscheme default") -- fallback aún más genérico
  end
  return
end

-- Configuración de Tokyonight (opcional, los valores por defecto son buenos)
-- Ver https://github.com/folke/tokyonight.nvim#configuration
tokyonight.setup({
  style = "storm", -- "storm", "night", "moon", "day"
  light_style = "day", -- Estilo para cuando 'background' es 'light'
  transparent = false, -- Habilitar fondo transparente. Si tu terminal ya tiene transparencia, ponlo a true.
  terminal_colors = true, -- Definir colores de la terminal
  styles = {
    -- Estilos para componentes específicos de la UI
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    -- Background de las ventanas flotantes de LSP, Telescope, etc.
    sidebars = "dark", -- "dark", "transparent" . 'dark' usa el color de fondo del tema.
    floats = "dark",   -- "dark", "transparent" . 'dark' usa el color de fondo del tema.
  },
  -- Personalizar colores (ver la documentación de tokyonight para la lista completa de colores)
  -- on_colors = function(colors)
  --   colors.hint = colors.orange
  --   colors.error = "#ff0000"
  -- end,
  -- Personalizar highlights (ver la documentación de tokyonight)
  -- on_highlights = function(highlights, colors)
  --   highlights.MyCustomHighlight = { fg = colors.blue, bg = colors.bg_dark, bold = true }
  -- end,
})

-- Aplicar el colorscheme
-- Es importante que esto se haga DESPUÉS de `tokyonight.setup()`
local apply_colorscheme = function()
    local apply_status_ok, msg = pcall(vim.cmd, "colorscheme tokyonight")
    if not apply_status_ok then
        vim.notify("Error al aplicar colorscheme tokyonight: " .. tostring(msg), vim.log.levels.ERROR)
        -- Intentar fallback si la aplicación falla también
        pcall(vim.cmd, "colorscheme habamax")
        return
    end
    vim.notify("Tema 'tokyonight' (estilo storm) cargado y aplicado.", vim.log.levels.INFO)
end

apply_colorscheme()
