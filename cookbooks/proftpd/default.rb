node.validate! do
  {
    proftpd: {
      server_admin: string
    }
  }
end

package 'epel-release'
package 'proftpd'
package 'proftpd-postgresql'

service 'proftpd' do
  action [:enable, :start]
end

template '/etc/proftpd.conf' do
  owner 'root'
  group 'root'
  mode '640'
  notifies :restart, 'service[proftpd]'
end
