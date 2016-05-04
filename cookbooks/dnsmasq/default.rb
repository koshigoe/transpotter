package 'dnsmasq'

service 'dnsmasq' do
  action [:enable, :start]
end

template '/etc/dnsmasq.conf' do
  owner 'root'
  group 'root'
  mode '0644'
end
