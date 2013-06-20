scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:join(start, end, c)
	return join(map(range(a:start, a:end), "getline('.')"), a:c)
endfunction


function! jplus#join(c) range
	let c = a:c
	if type(c) == type(0)
		let c = nr2char(c)
	endif
	if c !~ '[[:print:]]'
		return 0
	endif
	
	let start = a:firstline
	let end = a:lastline + (a:firstline == a:lastline)
	if a:firstline != a:lastline && col('.') == 1
		let end = end - 1
	endif

	echo c
	let line = getline(start)
\			 . c
\			 . join(map(range(start + 1, end),
\				'matchstr(getline(v:val), ''^\s*\zs.*'')'), c)
	call setline(start, line)

	if start+1 <= end
		let tmp = @*
		execute start+1 . ',' . end 'delete'
		let @* = tmp
	endif
	normal! k
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

