nnoremap <C-M-Right> :cnext<CR>zz
nnoremap <C-M-Left> :cprev<CR>zz
nnoremap <leader>Right :lnext<CR>zz
nnoremap <leader>Left :lprev<CR>zz
nnoremap <C-q> :call ToggleQFList(1)<CR>

let g:dapc_qf_l = 0
let g:dapc_qf_g = 0

fun! ToggleQFList(global)
    if a:global
        if g:dapc_qf_g == 1
            let g:dapc_qf_g = 0
            cclose
        else
            let g:dapc_qf_g = 1
            copen
        end
    else
        if g:dapc_qf_l == 1
            let g:dapc_qf_l = 0
            lclose
        else
            let g:dapc_qf_l = 1
            lopen
        end
    endif
endfun
