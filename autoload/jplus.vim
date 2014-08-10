scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:extend_list(list)
	return empty(a:list)    ? {}
\		 : len(a:list) == 1 ? a:list[0]
\		 : extend(deepcopy(a:list[0]), s:extend_list(a:list[1:]))
endfunction



function! jplus#getchar()
	let c = getchar()
	if type(c) == type(0)
		return nr2char(c)
	endif
	if c !~ '[[:print:]]'
		return 0
	endif
endfunction


function! s:join_list(list, c, ignore, left_match, right_match)
	let list = filter(a:list, 'len(v:val) && !(a:ignore != "" && (v:val =~ a:ignore))')
	let result = list[0]
	for i in list[1:]
		let result = matchstr(result, a:left_match) . a:c . matchstr(i, a:right_match)
	endfor
	return result
endfunction



function! s:join(config)
	let ignore =  a:config.ignore_pattern
	let left_matchstr = a:config.left_matchstr_pattern
	let right_matchstr = a:config.right_matchstr_pattern
	let c = substitute(a:config.delimiter_format, '%c', a:config.delimiter, "g")
	let start = a:config.firstline
	let lastline = a:config.lastline
	let end = lastline + (start == lastline)
	let matchstr_range = [1, 0]

	if end > line("$")
		return
	endif

	let line = s:join_list(getline(start, end), c, ignore, left_matchstr, right_matchstr)

	let view = winsaveview()
	call setline(start, line)

	if start+1 <= end
		silent execute start+1 . ',' . end 'delete _'
	endif

	if end <= line("$")
		normal! -1
	endif
	call winrestview(view)
endfunction




let g:jplus#default_config = {
\	"_" : {
\		"left_matchstr_pattern" : '.*',
\		"right_matchstr_pattern" : '\s*\zs.*',
\		"ignore_pattern" : '',
\		"delimiter" : " ",
\		"delimiter_format" : "%c",
\	},
\	"bash" : {
\		"left_matchstr_pattern" : '^.\{-}\%(\ze\s*\\$\|$\)',
\	},
\	"c" : {
\		"left_matchstr_pattern" : '^.\{-}\%(\ze\s*\\$\|$\)',
\	},
\	"cpp" : {
\		"left_matchstr_pattern" : '^.\{-}\%(\ze\s*\\$\|$\)',
\	},
\	"ruby" : {
\		"left_matchstr_pattern" : '^.\{-}\%(\ze\s*\\$\|$\)',
\	},
\	"python" : {
\		"left_matchstr_pattern" : '^.\{-}\%(\ze\s*\\$\|$\)',
\	},
\	"vim" : {
\		"right_matchstr_pattern" : '^\s*\\\s*\zs.*\|\s*\zs.*',
\	},
\	"zsh" : {
\		"left_matchstr_pattern" : '^.\{-}\%(\ze\s*\\$\|$\)',
\	},
\}


let g:jplus#config = get(g:, "jplus#config", {})

function! jplus#get_config(filetype, ...)
	return s:extend_list([
\		get(g:jplus#default_config, "_", {}),
\		get(g:jplus#config, "_", {}),
\		get(g:jplus#default_config, a:filetype, {}),
\		get(g:jplus#config, a:filetype, {}),
\		get(a:, 1, {})
\	])
endfunction


let g:jplus#input_config = get(g:, "jplus#input_config", {})

function! jplus#get_input_config(input, filetype, ...)
	return s:extend_list([
\		get(g:jplus#default_config, "_", {}),
\		get(g:jplus#config, "_", {}),
\		get(g:jplus#input_config, "_", {}),
\		get(g:jplus#default_config, a:filetype, {}),
\		get(g:jplus#config, a:filetype, {}),
\		{ "delimiter" : a:input },
\		get(g:jplus#input_config, a:input, {}),
\		get(a:, 1, {})
\	])
endfunction



function! jplus#join(config) range
	if &modifiable == 0
		return
	endif
	let config = extend({
\		"firstline" : a:firstline,
\		"lastline"  : a:lastline,
\	}, a:config)
	call s:join(config)
endfunction


function! jplus#mapexpr_join(...)
	let g:jplus_tmp_config = get(a:, 1, {})
	return ":call jplus#join(g:jplus_tmp_c, g:jplus_tmp_config)\<CR>"
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
