$:.unshift(File.dirname(__FILE__) + "/../lib/drnic")
require "rubygems"
require "show_in_github"

url = ShowInGitHub.url_for(ENV['GIT_FILEPATH'])
if url
  lines=''
  lines = "#{ENV['GIT_LINE_START']}-#{ENV['GIT_LINE_END']}" if ENV['GIT_LINE_START']
   `openUrl #{url}#L#{lines}`
else
  puts "File/project not a git repository or not pushed to a github repository"
end
