package 'dnsmasq'

service 'dnsmasq' do
  action [:enable, :start]
end

template '/etc/dnsmasq.d/address.conf' do
  owner 'root'
  group 'root'
  mode '0644'

  notifies :restart, 'service[dnsmasq]'
end
