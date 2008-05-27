$:.unshift(File.dirname(__FILE__) + "/../lib")
require "rubygems"
require "show_in_github"

url = ShowInGitHub.url_for(ENV['VIM_FILEPATH'])
if url
  lines=''
  lines = "#{ENV['VIM_START_LINE']}-#{ENV['VIM_END_LINE']}" if ENV['VIM_START_LINE']
   `openUrl #{url}#L#{lines}`
else
  puts "File/project not a git repository or not pushed to a github repository"
end
