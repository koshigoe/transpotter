require 'itamae/secrets'
node[:secrets] = Itamae::Secrets(File.join(__dir__, "../.secrets/#{node[:stage]}"))

include_recipe '../cookbooks/network-scripts/vagrant.rb'
include_recipe '../cookbooks/environment/default.rb'
include_recipe '../cookbooks/resolv/default.rb'
include_recipe '../cookbooks/proftpd/default.rb'
include_recipe '../cookbooks/git/default.rb'
include_recipe '../cookbooks/ruby/default.rb'
include_recipe '../cookbooks/pip/default.rb'
include_recipe '../cookbooks/aws-cli/default.rb'
