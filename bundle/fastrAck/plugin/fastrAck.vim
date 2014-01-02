" NOTE: You must install the fastrAck program in your path, or modify this to
" point to it
if !exists("g:fastrackprg")
	let g:fastrackprg="fastrAck "
endif


nnoremap <leader>g :set operatorfunc=<SID>fastrAckOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>fastrAckOperator(visualmode())<cr>
nnoremap <leader>G :set operatorfunc=<SID>fastrAckDefOperator<cr>g@
vnoremap <leader>G :<c-u>call <SID>fastrAckDefOperator(visualmode())<cr>

if !exists("g:fastrackprefix")
  let g:fastrackprefix=""
  let g:fastracksuffix = ""
endif

function! s:fastrAckDefOperator(type)
  try
    let g:fastrackprefix = "\\bdef\\b.*\\b"
    let g:fastracksuffix = "\\b"
    call <SID>fastrAckOperator(a:type)
  finally
    let g:fastrackprefix = ""
    let g:fastracksuffix = ""
  endtry
endfunction

function! s:fastrAckOperator(type)
    let saved_unnamed_register = @@

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif


"    silent execute "grep! -R " . shellescape(@@) . " ."
    call <SID>fastrAck("grep!", shellescape(g:fastrackprefix . @@ . g:fastracksuffix))
    copen

    let @@ = saved_unnamed_register
endfunction


function! s:fastrAck(cmd, args)
    redraw
    echo "Searching ... " . a:args

    let grepprg_bak=&grepprg
    let grepformat_bak=&grepformat
    try
        let &grepprg=g:fastrackprg
        silent execute a:cmd . " " . a:args
    finally
        let &grepprg=grepprg_bak
        let &grepformat=grepformat_bak
    endtry

    if a:cmd =~# '^l'
        botright lopen
    else
        botright copen
    endif

    exec "nnoremap <silent> <buffer> q :ccl<CR>" 

    redraw!
endfunction

function! s:fastrAckFromSearch(cmd, args)
    let search =  getreg('/')
    " translate vim regular expression to perl regular expression.
    let search = substitute(search,'\(\\<\|\\>\)','\\b','g')
    call s:fastrAck(a:cmd, '"' .  search .'" '. a:args)
endfunction

command! -bang -nargs=* -complete=file FastrAck call s:fastrAck('grep<bang>',<q-args>)
command! -bang -nargs=* -complete=file FastrAckAdd call s:fastrAck('grepadd<bang>', <q-args>)
command! -bang -nargs=* -complete=file FastrAckFromSearch call s:fastrAckFromSearch('grep<bang>', <q-args>)
