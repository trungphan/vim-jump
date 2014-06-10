
function! jump#JumpToFile()

    if (!exists("g:jump_from_pat"))
        let g:jump_from_pat=["/src/main/java/\\(.*\\)\\.java$", "/src/test/java/\\(.*\\)Test\\.java$"]
    endif

    if (!exists("g:jump_to_pat"))
        let g:jump_to_pat=["/src/test/java/\\1Test.java", "/src/main/java/\\1.java"]
    endif

    let currpath=expand("%:p")
    for i in range(len(g:jump_from_pat))
        if (currpath =~ ".*" . g:jump_from_pat[i])
            let destpath=substitute(currpath, g:jump_from_pat[i], g:jump_to_pat[i], "")
            if (bufexists(destpath))
                execute 'buffer ' . destpath
            elseif (filereadable(destpath) || confirm("Create file: " . fnamemodify(destpath, ":t") . "?", "&yes\n&no", 1) == 1)
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
