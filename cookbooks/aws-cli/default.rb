include_recipe '../pip/default.rb'

execute 'pip install awscli' do
  not_if 'which aws'
end
