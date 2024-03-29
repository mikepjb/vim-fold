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

augroup fold
  au! Filetype markdown :call MarkdownEnvironment()
  if exists('g:vim_fold_use-tab')
    noremap <tab> za
  endif
  au! BufNewFile,BufRead * set foldenable foldlevel=1
augroup END
