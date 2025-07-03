-- lua/user/plugins.lua

-- Autoinstalación de packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
  print("Packer.nvim instalado. Reinicia Neovim.")
  return true
end

-- Solo se ejecuta cuando se llama explícitamente con PackerCompile o PackerSync
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  vim.notify("Error al cargar packer: " .. tostring(packer), vim.log.levels.ERROR)
  return
end

-- Configuración de la ventana flotante de Packer
packer.init({
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'rounded' })
    end;
  };
})

-- Mis plugins
return packer.startup(function(use)
  -- Packer puede gestionarse a sí mismo
  use 'wbthomason/packer.nvim'

  -- Explorador de archivos
  use {
    'nvim-tree/nvim-tree.lua',
    requires = { 'nvim-tree/nvim-web-devicons' }, -- Opcional, para iconos
  }

  -- Pestañas/Buffers
  use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}

  -- Terminal integrada
  use {"akinsho/toggleterm.nvim", tag = '*', config = function() require("user.toggleterm") end}

  -- Buscador Fuzzy (Telescope)
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  -- Opcional: para mejorar el rendimiento del filtrado en telescope si FZF está instalado
  -- use {
  --   'nvim-telescope/telescope-fzf-native.nvim',
  --   run = 'make',
  --   cond = function() return vim.fn.executable 'make' == 1 end, -- Solo si 'make' está disponible
  -- }

  -- Autocompletado (nvim-cmp)
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp', -- Fuentes LSP
      'hrsh7th/cmp-buffer',   -- Fuentes del buffer
      'hrsh7th/cmp-path',     -- Fuentes de rutas
      'hrsh7th/cmp-cmdline',  -- Fuentes de línea de comandos
      'saadparwaiz1/cmp_luasnip', -- Integración de snippets
      'L3MON4D3/LuaSnip', -- Motor de Snippets
      -- 'rafamadriz/friendly-snippets', -- Colección de snippets (opcional)
    }
  }

  -- LSP (Language Server Protocol)
  use {
    'neovim/nvim-lspconfig', -- Colección de configuraciones para LSP
    requires = {
      {'williamboman/mason.nvim'}, -- Gestor de paquetes para LSPs
      {'williamboman/mason-lspconfig.nvim'}, -- Puente entre mason y lspconfig
      -- {'b0o/schemastore.nvim'}, -- Opcional: para esquemas JSON con jsonls
    }
  }

  -- Tema de colores
  use { "folke/tokyonight.nvim" }

  -- Aquí añadiremos más plugins en los siguientes pasos

  -- Sincronizar automáticamente Packer después de actualizar este archivo
  if Packer_Bootstrap then
    require('packer').sync()
  end
end)

-- Nota: Después de añadir nuevos plugins aquí, necesitarás:
-- 1. Guardar este archivo.
-- 2. Abrir Neovim y ejecutar :PackerSync
