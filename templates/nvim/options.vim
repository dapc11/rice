" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-l>', 'n') ==# ''
  nnoremap <silent> <C-L> :let @/ = ""<CR>
endif
