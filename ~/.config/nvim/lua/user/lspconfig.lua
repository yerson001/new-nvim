-- lua/user/lspconfig.lua
local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  vim.notify("Error al cargar nvim-lspconfig: " .. tostring(lspconfig), vim.log.levels.ERROR)
  return
end

local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
  vim.notify("Error al cargar mason: " .. tostring(mason), vim.log.levels.ERROR)
  return
end

local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status_ok then
  vim.notify("Error al cargar mason-lspconfig: " .. tostring(mason_lspconfig), vim.log.levels.ERROR)
  return
end

local cmp_nvim_lsp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status_ok then
  vim.notify("Error al cargar cmp_nvim_lsp: " .. tostring(cmp_nvim_lsp), vim.log.levels.WARN)
  -- Continuar aunque cmp_nvim_lsp no esté, pero el autocompletado LSP no funcionará bien.
end

-- Configuración de los iconos para diagnósticos (requiere Nerd Font)
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Configuración global de diagnósticos
vim.diagnostic.config({
  virtual_text = { spacing = 4, prefix = '●' }, -- Mostrar diagnósticos inline
  signs = true,
  underline = true,
  update_in_insert = false, -- No actualizar diagnósticos en modo inserción
  severity_sort = true,
  float = { -- Configuración para la ventana flotante de diagnósticos
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always", -- "always", "if_many"
    header = "",
    prefix = "",
  },
})

-- Estilo de las ventanas flotantes para hover y signature help
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, { border = "rounded", focusable = false }
)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, { border = "rounded", focusable = false }
)

-- Mapeos de teclado comunes para LSP. Se activarán en el `on_attach` de cada servidor.
local on_attach = function(client, bufnr)
  -- vim.notify("LSP attached: " .. client.name .. " to buffer " .. bufnr, vim.log.levels.DEBUG)

  local map = vim.keymap.set
  -- Opciones comunes para los mapeos LSP
  local bufopts = { noremap=true, silent=true, buffer=bufnr }

  map('n', 'K', vim.lsp.buf.hover, bufopts) -- Ver documentación al pasar el cursor
  map('n', 'gd', vim.lsp.buf.definition, bufopts) -- Ir a la definición
  map('n', 'gD', vim.lsp.buf.declaration, bufopts) -- Ir a la declaración
  map('n', 'gi', vim.lsp.buf.implementation, bufopts) -- Ir a la implementación
  map('n', 'gy', vim.lsp.buf.type_definition, bufopts) -- Ir a la definición de tipo
  map('n', 'gr', vim.lsp.buf.references, bufopts) -- Mostrar referencias
  map('n', '<leader>rn', vim.lsp.buf.rename, bufopts) -- Renombrar símbolo
  map({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, bufopts) -- Acciones de código

  map('n', '<leader>ld', vim.diagnostic.open_float, bufopts) -- Mostrar diagnósticos del buffer (ld para lsp diagnostics)
  map('n', '[d', vim.diagnostic.goto_prev, bufopts) -- Ir al diagnóstico anterior
  map('n', ']d', vim.diagnostic.goto_next, bufopts) -- Ir al diagnóstico siguiente

  map('i', '<C-k>', vim.lsp.buf.signature_help, bufopts) -- Ayuda con la firma de la función (en modo inserción)

  -- Formateo: Solo si el LSP lo soporta y no hay otro formateador.
  -- Es mejor usar un plugin dedicado como conform.nvim o null-ls para formateo.
  -- if client.server_capabilities.documentFormattingProvider then
  --   map({'n', 'v'}, '<leader>lf', function() vim.lsp.buf.format({ async = true }) end, bufopts) -- lf para lsp format
  -- end

  -- Habilitar autocompletado de nvim-cmp para este buffer
  -- Esto se hace obteniendo las capabilities del cliente y actualizándolas.
  -- La configuración de capabilities global ya debería manejar esto, pero podemos ser explícitos.
  if client.server_capabilities.completionProvider and cmp_nvim_lsp then
     -- Ya se establecen las capabilities globales en la configuración del servidor.
     -- vim.notify("LSP " .. client.name .. " completion provider enabled for nvim-cmp.", vim.log.levels.DEBUG)
  end

  -- Ejemplo de configuración específica del cliente si es necesario
  if client.name == "tsserver" then
    client.server_capabilities.documentFormattingProvider = false -- Ejemplo: deshabilitar formateo si se usa Prettier
  end
end

-- Capacidades globales para los servidores LSP, integrando con nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
if cmp_nvim_lsp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  vim.notify("Global LSP capabilities updated for nvim-cmp.", vim.log.levels.DEBUG)
else
  vim.notify("cmp_nvim_lsp no disponible, las capabilities globales de LSP no se modificarán para nvim-cmp.", vim.log.levels.WARN)
end


-- Inicializar Mason.
mason.setup({
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

-- Lista de servidores LSP que se deben instalar y configurar automáticamente.
-- El usuario deberá ejecutar :Mason para ver la lista completa e instalar los que necesite.
local servers_to_ensure_installed = {
  "lua_ls",   -- Para el desarrollo de la configuración de Neovim
  "jsonls",   -- Útil para muchos archivos de configuración
  "yamlls",   -- Para YAML
  "bashls",   -- Para scripts de Bash
  "marksman", -- Para Markdown
  -- "pyright",  -- Descomentar si se trabaja con Python
  -- "tsserver", -- Descomentar si se trabaja con TypeScript/JavaScript
  -- "rust_analyzer",
  -- "gopls",
  -- "jdtls" -- para Java (requiere configuración adicional)
}

mason_lspconfig.setup({
  ensure_installed = servers_to_ensure_installed,
  automatic_installation = true, -- Instalar automáticamente los servidores de `ensure_installed` al iniciar.
})

-- Configurar cada servidor LSP.
mason_lspconfig.setup_handlers {
  -- La función por defecto. Se llamará para cada servidor LSP instalado por Mason.
  function(server_name)
    local opts = {
      on_attach = on_attach,
      capabilities = capabilities, -- Usar las capabilities globales modificadas por nvim-cmp
    }

    -- Configuraciones específicas por servidor
    if server_name == "lua_ls" then
      opts.settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim", "_G" } }, -- Añadir _G para evitar falsos positivos con funciones globales personalizadas
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false, -- Evitar que revise node_modules, etc.
          },
          telemetry = { enable = false },
        },
      }
    end

    if server_name == "jsonls" then
      local schemastore_ok, schemastore = pcall(require, "schemastore")
      if schemastore_ok then
        opts.settings = {
            json = {
                schemas = schemastore.json.schemas(),
                validate = { enable = true },
            }
        }
        vim.notify("schemastore.nvim cargado para jsonls.", vim.log.levels.INFO)
      else
        vim.notify("schemastore.nvim no encontrado, esquemas JSON no se cargarán automáticamente para jsonls. Considera instalar 'b0o/schemastore.nvim'.", vim.log.levels.WARN)
      end
    end

    lspconfig[server_name].setup(opts)
    -- vim.notify("LSP configurado: " .. server_name, vim.log.levels.DEBUG)
  end,

  -- Ejemplo para JDTLS (Java) que requiere más configuración
  -- ["jdtls"] = function ()
  --   -- Configuración específica para jdtls
  --   -- Ver la documentación de nvim-jdtls para una configuración completa
  --   lspconfig.jdtls.setup({
  --       capabilities = capabilities,
  --       on_attach = on_attach,
  --       -- cmd = { ... }
  --       -- root_dir = ...
  --   })
  -- end,
}

-- Comando para facilitar la instalación de los LSPs definidos en `servers_to_ensure_installed`
vim.api.nvim_create_user_command('MasonInstallEnsured', function()
  if #servers_to_ensure_installed > 0 then
    vim.cmd('MasonInstall ' .. table.concat(servers_to_ensure_installed, ' '))
  else
    vim.notify("No hay servidores en 'servers_to_ensure_installed'.", vim.log.levels.INFO)
  end
end, { desc = "Instalar todos los LSPs de 'ensure_installed' con Mason" })

vim.notify("Configuración de LSP (lspconfig, mason) cargada.", vim.log.levels.INFO)
