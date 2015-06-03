github.vim 
=
http://github.com/solars/github_vim/

I tried to remove the dependency on drnics github-tmbundle scripts in this branch,
please report any errors and feel free to correct/suggest/add.

##Description


This is a quick and dirty vim plugin to use some github features locally from vim.

It enables you to:
  
  - open a link to the corresponding github file of a local vim selection
  - add a comment to the corresponding github commit of a locally selected line
  - yank a link to the corresponding github file of a local vim selection into the system clipboard

##Suggested installation

The file structure should be clear, just copy the github.vim into ~/.vim/plugin/

##Usage

  - Comment Commit: on the relevant line Press 'ghc' in normal mode
  - Open Selection: create a selection in visual mode and press 'gho'
  - Yank Selection: create a selection in visual mode and press 'ghy'

To remap the keybinding in your ~/.vimrc use:

  - map <F5> <Plug>GithubOpen
  - map <F6> <Plug>GithubComment

##Notes

Since this is my first vim plugins, feel free to send corrections or improvements :)
sol@textmode.at
