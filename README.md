# jplus.vim

任意の区切り文字を挿入したりして行結合を行うためのプラグインです。


## Screencapture

#### 任意の文字を挿入して結合する

![jplus1](https://cloud.githubusercontent.com/assets/214488/3864410/0e52b254-1f5c-11e4-9f89-3c624dc72936.gif)

#### 先頭の \ を取り除いて結合する

![jplus2](https://cloud.githubusercontent.com/assets/214488/3864436/f747a67c-1f5c-11e4-8918-45bfa0a2aced.gif)

## Example

```vim
" J の挙動を jplus.vim で行う
nmap J <Plug>(jplus)

" filetype=vim で凝結号する際に行頭の \ を取り除いて結合する設定を行う
let g:jplus#config = {
\	"vim" : {
\		"ignore_pattern" : '^\s*"[^"]*',
\		"matchstr_pattern" : '\s*\\\s*\zs.*\|\s*\zs.*'
\	}
\}

" getchar() を使用して挿入文字を入力します
nmap <Leader>J <Plug>(jplus-getchar)
vmap <Leader>J <Plug>(jplus-getchar)

" input() を使用したい場合はこちらを使用して下さい
" nmap <Leader>J <Plug>(jplus-input)
" vmap <Leader>J <Plug>(jplus-input)
```


