
function! jump#JumpToFile()

    if (!exists("g:jump_pattern"))
        let g:jump_pattern = [
                    \ ["/src/main/java/\\(.*\\)\\.java$", "/src/test/java/\\1Test.java"],
                    \ ["/src/test/java/\\(.*\\)Test\\.java$", "/src/main/java/\\1.java"]
                    \ ]
    endif


    let currpath=expand("%:p")
    for i in range(len(g:jump_pattern))
        if (currpath =~ ".*" . g:jump_pattern[i][0])
            let destpath=substitute(currpath, g:jump_pattern[i][0], g:jump_pattern[i][1], "")
            if (bufexists(destpath))
                execute 'buffer ' . destpath
            elseif (filereadable(destpath))
                execute 'edit ' . destpath
            elseif (len(g:jump_pattern[i]) > 2 && g:jump_pattern[i][2] == "skip")
                continue
            elseif confirm("Create file: " . fnamemodify(destpath, ":t") . "?", "&yes\n&no", 1) == 1)
                execute 'edit ' . destpath
                let folder = expand('%:h')
                if !isdirectory(folder) && confirm("Folder not exist: " . folder . ". Create now? ", "&yes\n&no", 1) == 1
                    call mkdir(folder, 'p')
                endif
            endif
            break
        endif
    endfor
endfunction
