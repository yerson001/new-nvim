-- Configuración de vim-airline
vim.g.airline_powerline_fonts = 1
vim.g.airline_theme = 'dracula'  -- Puedes cambiar el tema aquí

-- Mostrar la hora en la barra de estado
vim.cmd [[
function! AirlineInit()
  let g:airline_section_z = airline#section#create(['%{strftime("%H:%M:%S")}', ' %p%% '])
endfunction
autocmd User AirlineAfterInit call AirlineInit()
]]
