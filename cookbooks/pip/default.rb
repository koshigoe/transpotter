package 'python'

execute 'easy_install pip' do
  not_if 'which pip'
end
