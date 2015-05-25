" http://github.com/solars/github-vim/
" sol@textmode.at

if exists("loaded_github") || &cp 
  finish 
endif


" --- main functions --- "

function! s:Open() range
  if empty(s:RepositoryRoot()) || empty(s:Remote())
    call s:error("File not in repository or no remote found!")
  else
    let url = s:ReposUrl().'/'.s:RelPath().'#L'.a:firstline.'-'.a:lastline
    call s:OpenUrl(url)
  end
endfunction

function! s:Yank()
  if empty(s:RepositoryRoot()) || empty(s:Remote())
    call s:error("File not in repository or no remote found!")
  else
    let url = s:ReposUrl().'/'.s:RelPath().'#L'.a:firstline.'-'.a:lastline
    call s:YankUrl(url)
  end
endfunction

function! s:Comment()
  if empty(s:RepositoryRoot()) || empty(s:Remote())
    call s:error("File not in repository or no remote found!")
  else
    let url = s:ReposUrl().'/'.s:RelPath().'#L'.a:firstline.'-'.a:lastline
    let line = line('.')
    let output = s:CdExec(s:RepositoryRoot(),'git blame -l -s -L '.line.','.line.' '.s:RelPath())
    if empty(output)
      s:error("No commit found")
      return
    end
    let commit = split(output)[0]
    let index=s:CommitIndex(commit)
    let url = s:ProjectUrl().'/commit/'.commit.'/'.s:RelPath().'#diff-'.index
    call s:OpenUrl(url)
  endif
endfunction


" --- key mappings --- "

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

if !hasmapto('<Plug>GithubYank', 'v')
  vmap <unique>ghy <Plug>GithubYank
endif
vnoremap <unique> <script> <Plug>GithubYank <SID>Yank
vnoremap <silent> <SID>Yank :call <SID>Yank()<CR>

" --- helpers --- "

" repository root path of current file
function! s:RepositoryRoot() "+error checks
  if !exists('b:repos_root')
    let dir = expand("%:p:h")
    let rel_path = s:CdExec(dir,'git rev-parse --show-cdup')
    if !empty(matchstr(rel_path,'fatal'))
      return
    end
    let rel_path = substitute(rel_path, "\n",'','g')
    let b:repos_root = simplify(dir.'/'.rel_path)
  endif
  return b:repos_root
endfunction

" current branch name
function! s:CurrentBranch()
  if !exists('b:branch')
    let branches = s:CdExec(expand("%:p:h"),"git branch")
    if empty(branches)
      return
    endif
    let b:branch = matchstr(branches, '\* \zs.\{-}\ze\n.*')
  endif
  return b:branch
endfunction

" relative path of the current file to the repository root 
function! s:RelPath()
  if !exists('b:rel_path')
    let root = escape(s:RepositoryRoot(),'./')
    let file = expand('%:p')
    let b:rel_path = strpart(file,matchend(file, root))
  endif
  return b:rel_path
endfunction

" finds the github remote repository identifier
" precedence: github > origin > other
function! s:Remote()
  if !exists('b:remote')
    let remotes = split(s:CdExec(expand("%:p:h"),'git remote -v'),"\n")
    let github_remotes = filter(remotes, 'v:val =~ "github\.com"')
    if empty(github_remotes)
      return
    endif
    let dict={}
    for line in github_remotes
      let [name,url]=remove(split(line),0,1)
      let dict[name]=url
    endfor
    let fallback = split(github_remotes[0])[1]
    if has_key(dict, 'github')
      let b:remote = dict['github']
    elseif has_key(dict,'origin')
      let b:remote = dict['origin']
    else
      let b:remote = fallback
    end
  endif
  return b:remote
endfunction

" the github project url
function! s:ProjectUrl()
  if !exists('b:project_url')
    let remote_url = s:Remote()
    let user = matchstr(remote_url,'.*github\.com[:/]\zs[^/]\+\ze\/.*')
    let project = matchstr(remote_url,'.*github\.com[:/][^/]\+\/\zs[^.]\+\ze\.git')
    let b:project_url = 'http://github.com/'.user.'/'.project
  endif
  return b:project_url
endfunction

" the github repository url
function! s:ReposUrl()
  if !exists('b:repos_url')
    let b:repos_url = s:ProjectUrl().'/tree/'.s:CurrentBranch()
  endif
  return b:repos_url
endfunction

" index of a filename in the diff output
function! s:CommitIndex(commit)
  if !exists('b:index')
    let output = s:CdExec(s:RepositoryRoot(),'git diff --name-only '.a:commit.'^..'.a:commit)
    let b:index = index(split(output,'\n'),s:RelPath())
  endif
  return b:index
endfunction

" executes cmd in the given dir
function! s:CdExec(dir,cmd)
  let cur_dir=getcwd()
  exe 'lcd '.a:dir
  let output=system(a:cmd)
  exe 'lcd '.cur_dir
  return output
endfunction

function! s:EscapeUrl(str)
  return substitute(a:str,'\C[ !%#]','\\&','g')
endfunction

" print and set error msg
function! s:error(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl None
  let v:errmsg = a:msg
endfunction

" OpenURL helper
function! s:OpenUrl(url)
  if !exists(":OpenURL")
    let os = substitute(system('uname'), '\n', '', '')
    if has("gui_mac") || os == 'Darwin'
      command -bar -nargs=1 OpenURL :!open <args>
    elseif has("gui_win32")
      command -bar -nargs=1 OpenURL :!start cmd /cstart /b <args>
    elseif executable("sensible-browser")
      command -bar -nargs=1 OpenURL :!sensible-browser <args>
    endif
  endif
  if exists(":OpenURL")
    exe "OpenURL ".s:EscapeUrl(a:url)
  else
    call s:error('Please define the OpenURL cmd for your system (:help OpenURL)')
  endif
endfunction

" YankURL helper
function! s:YankUrl(url)
  let os = substitute(system('uname'), '\n', '', '')
  if has("gui_mac") || os == 'Darwin'
    silent call system('pbcopy', a:url)
  elseif has("gui_win32")
    silent call system('clip', a:url) 
  else
    silent call system('xsel --clipboard --input', a:url) 
  endif
endfunction
