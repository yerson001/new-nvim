-- Asegúrate de que Packer está instalado
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

-- Configuración de Packer
return require('packer').startup(function()
    use 'wbthomason/packer.nvim' -- Packer can manage itself

    -- Plugin para el árbol de archivos
    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function() require('plugin-config.nvim-tree') end,
        cmd = 'NvimTreeToggle'  -- Lazy load cuando se usa el comando NvimTreeToggle
    }

    -- LSP Config
    use {
        'neovim/nvim-lspconfig',
        config = function() require('plugin-config.lspconfig') end,
        event = 'BufReadPre'  -- Lazy load cuando se lee un buffer
    }

    -- Treesitter para resaltado de sintaxis
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
    -- Tema Dracula

    use {'dracula/vim',as = 'dracula',config = function()vim.cmd('colorscheme dracula')end}

    --use 'Mofiqul/dracula.nvim'

    -- Tema Monokai
    use {
        'tanvirtin/monokai.nvim',
        event = 'VimEnter'  -- Lazy load cuando se inicia Vim
    }

    -- Tema Sonokai
    use {
        'sainnhe/sonokai',
        event = 'VimEnter'  -- Lazy load cuando se inicia Vim
    }

    -- Autopairs para emparejamiento automático de caracteres
    use 'jiangmiao/auto-pairs'

    -- vim-airline y vim-airline-themes
    use {
        'vim-airline/vim-airline',
        requires = {
            'vim-airline/vim-airline-themes',
            'kyazdani42/nvim-web-devicons'  -- Para íconos
        },
        config = function() require('plugin-config.airline') end
    }

    -- toggleterm.nvim para terminales integradas
    use {"akinsho/toggleterm.nvim", tag = '*', config = function()
        require("toggleterm").setup()
      end}

    -- Plugin para Node.js
    use {
        'jose-elias-alvarez/nvim-lsp-ts-utils',
        requires = { 'neovim/nvim-lspconfig', 'nvim-lua/plenary.nvim' }
    }

    -- Otros plugins...
end)
