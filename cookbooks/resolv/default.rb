node.validate! do
  {
    resolv: array_of(string)
  }
end

template '/etc/resolv.conf' do
  owner 'root'
  group 'root'
  mode '0644'
end
