if exists("loaded_github") || &cp 
  finish 
endif

function! Gitopen() range
  let $GIT_LINE_START=a:firstline
  let $GIT_LINE_END=a:lastline
  let $GIT_FILEPATH=expand("%:p")
  rubyf $HOME/bin/github_open.rb
endfunction

function! Gitcomment()
  let $GIT_CURRENT_LINE = getline('.')
  let $GIT_FILEPATH = expand("%:p")
  rubyf $HOME/bin/github_comment.rb
endfunction

" example mappings for ~/.vimrc
" map <F5> :call Gitopen()<cr>
" map <F6> :call Gitcomment()<cr>
