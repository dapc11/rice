function! StatuslineGit()
  let l:branchname = GitBranch()

  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

function! LspStatus() abort
    let sl = ''
    if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
        let sl.='E:' .luaeval("vim.diagnostic.get_count(0, [[Error]])") . ', '
        let sl.='W:' .luaeval("vim.diagnostic.get_count(0, [[Warning]])") . ', '
        let sl.='H:' .luaeval("vim.diagnostic.get_count(0, [[Hint]])")
    else
        let sl.=''
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
set statusline+=%#Statusline#
set statusline+=\ %f
set statusline+=%m
set statusline+=%=
set statusline+=%#StatusLineNc#
set statusline+=\ %{FugitiveStatusline()}
set statusline+=\ %{LspStatus()}
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\
