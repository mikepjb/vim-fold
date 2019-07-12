function! MarkdownEnvironment()
  func! Foldexpr_markdown(lnum)
    let l1 = getline(a:lnum)

    if l1 =~ '^\s*$'
      " ignore empty lines
      return '='
    endif

    let l2 = getline(a:lnum+1)

    if  l2 =~ '^==\+\s*'
      " next line is underlined (level 1)
      return '>1'
    elseif l2 =~ '^--\+\s*'
      " next line is underlined (level 2)
      return '>2'
    elseif l1 =~ '^#'
      " current line starts with hashes
      return '>'.matchend(l1, '^#\+')
    elseif a:lnum == 1
      " fold any 'preamble'
      return '>1'
    else
      " keep previous foldlevel
      return '='
    endif
  endfunc

  setlocal foldexpr=Foldexpr_markdown(v:lnum)
  setlocal foldmethod=expr
endfunction

augroup markdown
  au! Filetype markdown :call MarkdownEnvironment()
augroup END

func! FoldOnComments()
  func! Foldexpr(lnum)
    let l1 = getline(a:lnum)
    let l2 = getline(a:lnum+1)

    if l1 =~ '^/.\?\*.*\\*.\?/$'
      return '>1'
    elseif l2 =~ '^/.\?\*.*\\*.\?/$'
      return '<1'
    else
      return '='
    endif
  endfunc

  setlocal foldexpr=Foldexpr(v:lnum)
  setlocal foldmethod=expr
endfunc

augroup commentFolding
  au! Filetype css :call FoldOnComments()
  au! Filetype javascript :call FoldOnComments()
augroup END
