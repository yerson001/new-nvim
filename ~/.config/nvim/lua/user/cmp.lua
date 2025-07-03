-- lua/user/cmp.lua
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  vim.notify("Error al cargar nvim-cmp: " .. tostring(cmp), vim.log.levels.ERROR)
  return
end

local luasnip_status_ok, luasnip = pcall(require, "luasnip")
if not luasnip_status_ok then
  vim.notify("Error al cargar luasnip: " .. tostring(luasnip), vim.log.levels.ERROR)
  return
end

-- Descomentar si se instala friendly-snippets y se quiere cargar
-- local lazy_load_friendly_snippets = function()
--    pcall(require, "luasnip.loaders.from_vscode").lazy_load()
-- end
-- lazy_load_friendly_snippets() -- Cargar snippets de VSCode (como friendly-snippets)


-- Iconos para el menú de completado (opcional, requiere Nerd Font)
local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = ""
}

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- Usa LuaSnip para expandir snippets
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- Scroll hacia arriba en la documentación
    ['<C-f>'] = cmp.mapping.scroll_docs(4),  -- Scroll hacia abajo en la documentación
    ['<C-Space>'] = cmp.mapping.complete(),  -- Mostrar completados (o completar si ya está visible)
    ['<C-e>'] = cmp.mapping.abort(),         -- Cerrar menú de completado
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Aceptar selección. `select = true` significa que si no hay nada seleccionado explícitamente, selecciona la primera opción.

    -- Tab y S-Tab para navegar entre sugerencias y snippets
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      -- elseif has_words_before() then -- Descomentar para autocompletar con Tab si hay texto antes
      --   cmp.complete()
      else
        fallback() -- fallback a la funcionalidad normal de Tab si no hay sugerencias/snippets
      end
    end, { "i", "s" }), -- "i" para modo inserción, "s" para modo selección (en snippets)

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback() -- fallback a la funcionalidad normal de Shift-Tab
      end
    end, { "i", "s" }),
  }),
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      -- Iconos
      vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "?", vim_item.kind)
      -- Nombre de la fuente (LSP, Snippet, Buffer, etc.)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snip]",
        buffer = "[Buff]",
        path = "[Path]",
        cmdline = "[Cmd]",
        nvim_lua = "[Lua]",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },    -- Fuente para LSP
    { name = 'luasnip' },     -- Fuente para LuaSnip
    { name = 'buffer', keyword_length = 3 },  -- Fuente para texto en el buffer actual (mínimo 3 caracteres)
    { name = 'path' },        -- Fuente para rutas del sistema de archivos
    -- { name = 'nvim_lua' }, -- Para la API de Lua de Neovim (si se está configurando Neovim)
  }),
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace, -- Reemplazar texto al confirmar
    select = false, -- No seleccionar automáticamente la primera opción al mostrar el menú
  },
  window = {
    completion = cmp.config.window.bordered({
        -- border = "rounded",
        -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        -- col_offset = -3,
        -- side_padding = 0,
    }),
    documentation = cmp.config.window.bordered({
        -- border = "rounded",
        -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
    }),
  },
  experimental = {
    ghost_text = false, -- true | { hl_group = 'Comment' } . Muestra sugerencias inline. Puede ser útil.
  },
})

-- Configuración para la línea de comandos (/)
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' } -- Fuentes para búsqueda en el buffer
  }
})

-- Configuración para la línea de comandos (:)
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },      -- Rutas de sistema
    { name = 'cmdline' }    -- Comandos de Neovim
  })
})

-- vim.notify("nvim-cmp y luasnip configurados.", vim.log.levels.INFO)
-- Ya no es necesario notificar desde aquí.
local luasnip_friendly_status, _ = pcall(require, "luasnip.loaders.from_vscode")
if luasnip_friendly_status then
    require("luasnip.loaders.from_vscode").lazy_load()
    vim.notify("Friendly snippets cargados (si están instalados).", vim.log.levels.INFO)
end
