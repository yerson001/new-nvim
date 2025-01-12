-- Mapeos de teclas personalizados
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Moverse con 'w', 'a', 's', 'd'
map('n', 'w', 'k', opts)
map('n', 'k', 'j', opts)
map('n', 'j', 'h', opts)
map('n', 'l', 'l', opts)

-- Mejor navegación para omnicomplete
map('i', '<C-j>', 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true })
map('i', '<C-k>', 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true })

-- Usar alt + hjkl para redimensionar ventanas
map('n', '<M-j>', ':resize -2<CR>', opts)
map('n', '<M-k>', ':resize +2<CR>', opts)
map('n', '<M-h>', ':vertical resize -2<CR>', opts)
map('n', '<M-l>', ':vertical resize +2<CR>', opts)

-- Remapear escape
map('i', 'lk', '<Esc>', opts)
map('i', 'kl', '<Esc>', opts)

-- Easy CAPS
map('i', '<C-u>', '<ESC>viwUi', opts)
map('n', '<C-u>', 'viwU<Esc>', opts)

-- Navegación de buffers
map('n', '<TAB>', ':bnext<CR>', opts)
map('n', '<S-TAB>', ':bprevious<CR>', opts)
map('n', '<C-z>', ':u<CR>', opts)

-- Guardar y salir
map('n', '<leader>ss', ':w<CR>', opts)
map('n', '<leader>qq', ':wq<CR>', opts)

-- Usar control-c en lugar de escape
map('n', '<C-c>', '<Esc>', opts)

-- Mejor tabulación
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

-- Mejor navegación de ventanas
map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)

-- Otros mapeos
map('n', '<leader>m', ':NvimTreeToggle<CR>', opts)  -- Asegúrate de que este mapeo esté correcto
map('n', '<C-V>', ':vsplit<CR>', opts)
map('n', '<C-p>', ':split<CR>', opts)
map('n', '<C-j>', ':ToggleTerm<CR>', opts)
map('n', '<C-r>', ':ToggleTerm direction=float<CR>', opts)
map('n', '<C-o>', ':IndentLinesToggle<CR>', opts)
map('n', '<F6>', ':vnew<CR>', opts)

-- Mapeos para cambiar entre temas
map('n', '<leader>1', ':lua set_colorscheme("dracula-vim")<CR>', opts)
map('n', '<leader>2', ':lua set_colorscheme("monokai")<CR>', opts)
map('n', '<leader>3', ':lua set_colorscheme("sonokai")<CR>', opts)

-- Ejecutar código C++ en una terminal integrada
map('n', '<F5>', ':w<CR>:ToggleTerm direction=horizontal cmd="g++ % -o %< && ./%<"<CR>', opts)

-- Abrir y cerrar terminales con <leader>j
map('n', '<leader>j', ':ToggleTerm<CR>', opts)
map('t', '<leader>j', '<C-\\><C-n>:ToggleTerm<CR>', opts)

-- Abrir terminal flotante con <leader>h
map('n', '<leader>h', ':lua toggle_floating_terminal()<CR>', opts)
map('t', '<leader>h', '<C-\\><C-n>:lua toggle_floating_terminal()<CR>', opts)
