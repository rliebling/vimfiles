"When the GUI starts, t_vb is reset to its default value.
"Reassert that no flash or beep is wanted.
set visualbell t_vb=

command! CpFileName call _CpFileName()
function! _CpFileName()
 let @* = expand("%:p")
endfunction

" from http://vim.wikia.com/wiki/Using_tab_pages
nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . tabpagenr()<CR>

set lines=34 columns=100

