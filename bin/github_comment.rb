$:.unshift(File.dirname(__FILE__) + "/../lib/drnic")
require "rubygems"
require "show_in_github"
 
url = ShowInGitHub.line_to_github_url(ENV['GIT_FILEPATH'], ENV['GIT_CURRENT_LINE'])
if url
  `openUrl #{url}`
else
  puts "File/project not a git repository or not pushed to a github repository; or an error occurred"
end
