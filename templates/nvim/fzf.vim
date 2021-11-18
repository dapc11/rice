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

let g:fzf_preview_window = ['down:50%', 'ctrl-h']

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
command! -bang ProjectFiles call fzf#vim#files('~/repos', <bang>0)

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
command! -bang -nargs=? GFiles call fzf#vim#gitfiles(<q-args>, <bang>0)
command! -bang -nargs=* History call s:history(<q-args>, fzf#vim#with_preview(), <bang>0)


nnoremap <silent> <leader>f :RG<cr>
nnoremap <silent> <leader>n :GFiles<cr>
nnoremap <silent> <leader>h :History<cr>
nnoremap <silent> <leader>N :GFiles?<cr>
nnoremap <silent> <leader><Leader> :AFFF<cr>
nnoremap <silent> <Leader>o :AF<cr>
nnoremap <silent> <Leader>O :AFF<cr>
nnoremap <Leader>d :AD<cr>
nnoremap <C-f> :BLines<cr>
nnoremap <C-p> :ProjectFiles<cr>

let loaded_netrwPlugin = 1
