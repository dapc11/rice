let g:fzf_nvim_statusline = 0 " disable statusline overwriting
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

command! -bang -nargs=* GGrep call fzf#vim#grep('git grep --line-number -- '.shellescape(<q-args>), 0, fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --hidden --line-number --no-heading --color=always --colors "path:none" --colors "path:style:bold" --colors "line:none" --colors "line:style:bold" --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let options = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  let options = fzf#vim#with_preview(options, 'right', 'ctrl-/')
  call fzf#vim#grep(initial_command, 1, options, a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" All files
command! -nargs=? -complete=dir AF
  \ call fzf#run(fzf#wrap({
  \   'source': 'rg --no-heading --files ~/ '.expand(<q-args>)
  \ }))

" All files
command! -nargs=? -complete=dir AFF
  \ call fzf#run(fzf#wrap({
  \   'source': 'rg --no-heading --files --hidden ~/ '.expand(<q-args>)
  \ }))

nnoremap <silent> <leader>G :GGrep<cr>
nnoremap <silent> <leader>f :Lines<cr>
nnoremap <silent> <leader>F :RG<cr>
nnoremap <silent> <leader>n :GFiles<cr>
nnoremap <silent> <leader>h :History<cr>
nnoremap <silent> <leader>N :GFiles?<cr>
nnoremap <silent> <leader><Leader> :AF<cr>
nnoremap <silent> <Leader>o :AFF<cr>
