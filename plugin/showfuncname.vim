" search function name

function! ShowFuncName()
        let lnum = line(".")
        let col = col(".")
        echohl ModeMsg
        echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
        echohl None
        call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun

map f :call ShowFuncName() <CR>
"nnoremap <leader>fn :call ShowFuncName() <CR>
