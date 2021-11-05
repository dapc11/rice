let g:fzf_nvim_statusline = 0 " disable stpatusline overwriting
let g:fzf_colors = {
            \ 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Constant'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'Normal'],
            \ 'border':  ['fg', 'Normal'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment'] }
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep('git grep --line-number -- '.shellescape(<q-args>),
  \ 0,
  \ fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}),
  \ <bang>0)
command! -nargs=? -complete=dir AFFF
  \ call fzf#run(fzf#wrap({
  \   'source': 'rg --no-heading --files --no-ignore-vcs --hidden . '.expand(<q-args>)
  \ }))
command! -nargs=? -complete=dir AF
  \ call fzf#run(fzf#wrap({
  \   'source': 'rg --no-heading --files ~/ '.expand(<q-args>)
  \ }))
command! -nargs=? -complete=dir AFF
  \ call fzf#run(fzf#wrap({
  \   'source': 'rg --no-heading --files --hidden ~/ '.expand(<q-args>)
  \ }))
command! -nargs=? -complete=dir AD
  \ call fzf#run(fzf#wrap({
  \   'source': 'rg ~/repos ~/personal_repos --max-depth 2 --hidden --files --null | xargs -0 dirname | sort | uniq '.expand(<q-args>)
  \ }))
nnoremap <silent> <leader>pg :GGrep<cr>
nnoremap <silent> <leader>f :Telescope live_grep<cr>
nnoremap <silent> <leader>b :Telescope buffers<cr>
nnoremap <silent> <leader>n :GFiles<cr>
nnoremap <silent> <leader>h :History<cr>
nnoremap <silent> <leader>N :GFiles?<cr>
nnoremap <silent> <leader><Leader> :AFFF<cr>
nnoremap <silent> <Leader>o :AF<cr>
nnoremap <silent> <Leader>O :AFF<cr>
nnoremap <Leader>d :AD<cr>
nnoremap <C-p> :Telescope find_files<cr>
nnoremap <C-f> :Telescope current_buffer_fuzzy_find<cr>

let loaded_netrwPlugin = 1
