set packpath^=/nix/store/idj30pxvw4ndm1g210d54wppx6ww2cvg-vim-pack-dir
set runtimepath^=/nix/store/idj30pxvw4ndm1g210d54wppx6ww2cvg-vim-pack-dir

set expandtab
set tabstop=4
set shiftwidth=4
let g:sneak#s_next = 1
let g:VM_leader = '\'

nnoremap <C-p> :Files<Cr>
nnoremap <C-g> :Rg<Cr>
" I don't use C-b anyway
nnoremap <C-b> :Buffers<Cr>

let g:airline#extensions#tabline#enabled = 1
