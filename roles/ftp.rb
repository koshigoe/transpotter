require 'itamae/secrets'
node[:secrets] = Itamae::Secrets(File.join(__dir__, '../secret'))

include_recipe '../cookbooks/environment/default.rb'
include_recipe '../cookbooks/proftpd/default.rb'
include_recipe '../cookbooks/git/default.rb'
include_recipe '../cookbooks/ruby/default.rb'
include_recipe '../cookbooks/pip/default.rb'
