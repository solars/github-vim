if exists("loaded_github") || &cp 
  finish 
endif

function! Gitopen() range
  let $VIM_START_LINE=a:firstline
  let $VIM_END_LINE=a:lastline
  let $VIM_FILEPATH=expand("%:p")
  silent! rubyf $HOME/bin/open_github.rb
endfunction

" example mapping for ~/.vimrc
" map <F5> :call Gitopen()<cr>
