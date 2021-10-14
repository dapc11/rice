function! GitBranch()
    "TODO: fix this so it gives instant respone
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()

  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   'W:%d|E:%d',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

function! LspStatus() abort
    let sl = ''
    if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
        let sl.='E:' .luaeval("vim.lsp.diagnostic.get_count(0, [[Error]])") . ', '
        let sl.='W:' .luaeval("vim.lsp.diagnostic.get_count(0, [[Warning]])")
    else
        let sl.='Lsp off'
    endif
    return sl
endfunction

let g:currentmode={
       \ 'n'  : 'n',
       \ 'v'  : 'v',
       \ 'V'  : 'vl',
       \ '' : 'vb',
       \ 'i'  : 'i',
       \ 'R'  : 'r',
       \ 'r'  : 'r',
       \ 'Rv' : 'rv',
       \ 'c'  : 'c',
       \ 't'  : 'f',
       \ 's'  : 'test',
       \}

set laststatus=2
set statusline=
set statusline+=%#NormalColor#%{(g:currentmode[mode()]=='n')?'\ \ normal\ ':''}
set statusline+=%#InsertColor#%{(g:currentmode[mode()]=='i')?'\ \ insert\ ':''}
set statusline+=%#ReplaceColor#%{(g:currentmode[mode()]=='r')?'\ \ replace\ ':''}
set statusline+=%#ReplaceColor#%{(g:currentmode[mode()]=='rv')?'\ \ v-replace\ ':''}
set statusline+=%#VisualColor#%{(g:currentmode[mode()]=='v')?'\ \ visual\ ':''}
set statusline+=%#VisualColor#%{(g:currentmode[mode()]=='vl')?'\ \ v-line\ ':''}
set statusline+=%#VisualColor#%{(g:currentmode[mode()]=='vb')?'\ \ v-block\ ':''}
set statusline+=%#NormalColor#%{(g:currentmode[mode()]=='c')?'\ \ command\ ':''}
set statusline+=%#NormalColor#%{(g:currentmode[mode()]=='f')?'\ \ finder\ ':''}
set statusline+=%#PmenuSel#
" Dont use Git in statusline due to major performance loss
" set statusline+=%{StatuslineGit()}
set statusline+=%#Statusline#
set statusline+=\ %f
set statusline+=%m
set statusline+=%=
set statusline+=%#StatusLineNc#
" set statusline+=%{LinterStatus()}
set statusline+=\ %{FugitiveStatusline()}
set statusline+=\ %{LspStatus()}
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 
