scriptencoding utf-8
if exists('g:loaded_jplus')
  finish
endif
let g:loaded_jplus = 1

let s:save_cpo = &cpo
set cpo&vim


noremap <silent> <Plug>(jplus-getchar)
\	:call jplus#join(getchar())<CR>

noremap <silent> <Plug>(jplus-getchar-with-space)
\	:call jplus#join(' ' . jplus#getchar() . ' ')<CR>


noremap <silent> <Plug>(jplus-input)
\	:call jplus#join(input("Input joint sep:"))<CR>

noremap <silent> <Plug>(jplus-input-with-space)
\	:call jplus#join(' ' . input("Input joint sep:") . ' ')<CR>


let &cpo = s:save_cpo
unlet s:save_cpo
