if exists("loaded_github") || &cp 
  finish 
endif

function! s:Open() range
  let $GIT_LINE_START=a:firstline
  let $GIT_LINE_END=a:lastline
  let $GIT_FILEPATH=expand("%:p")
  rubyf $HOME/bin/github_open.rb
endfunction

function s:Comment()
  let $GIT_CURRENT_LINE = getline('.')
  let $GIT_FILEPATH = expand("%:p")
  rubyf $HOME/bin/github_comment.rb
endfunction

if !hasmapto('<Plug>GithubComment', 'n')
  nmap <unique>ghc <Plug>GithubComment
endif
nnoremap <unique> <script> <Plug>GithubComment <SID>Comment
nnoremap <silent> <SID>Comment :call <SID>Comment()<CR>

if !hasmapto('<Plug>GithubOpen', 'v')
  vmap <unique>gho <Plug>GithubOpen
endif
vnoremap <unique> <script> <Plug>GithubOpen <SID>Open
vnoremap <silent> <SID>Open :call <SID>Open()<CR>

" override mappings with:
" map <F5> <Plug>GithubOpen
" map <F6> <Plug>GithubComment
