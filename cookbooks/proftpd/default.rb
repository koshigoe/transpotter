node.validate! do
  {
    proftpd: {
      server_admin: string
    }
  }
end

package 'epel-release'
package 'proftpd'

service 'proftpd' do
  action [:enable, :start]
end

template '/etc/proftpd.conf' do
  mode '640'
  notifies :restart, 'service[proftpd]'
end
