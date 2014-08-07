scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! jplus#getchar()
	let c = getchar()
	if type(c) == type(0)
		return nr2char(c)
	endif
	if c !~ '[[:print:]]'
		return 0
	endif
endfunction


function! jplus#join(c, ...) range
	let ignore =  get(a:, 1, '.*')
	let match_pattern = get(a:, 2, '.*')
	let c = a:c
	let start = a:firstline
	let end = a:lastline + (a:firstline == a:lastline)

	let next = join(map(filter(map(getline(start + 1, end), 'matchstr(v:val, match_pattern)'), 'len(v:val) && v:val !~ ignore'), 'matchstr(v:val, ''^\s*\zs.*'')'), c)
	if next == ""
		let line = matchstr(getline(start), match_pattern)
	else
		let line = matchstr(getline(start), match_pattern) . c . next
	endif
	call setline(start, line)

	if start+1 <= end
		silent execute start+1 . ',' . end 'delete _'
	endif
	normal! -1
endfunction


function! jplus#mapexpr_join(c, ...)
	let g:jplus_tmp_c = a:c
	let g:jplus_tmp_ignore = get(a:, 1, '.*')
	let g:jplus_tmp_match_pattern = get(a:, 2, '.*')
	return ":call jplus#join(g:jplus_tmp_c, g:jplus_tmp_ignore, g:jplus_tmp_match_pattern)\<CR>"
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
