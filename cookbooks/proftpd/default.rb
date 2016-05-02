node.validate! do
  {
    proftpd: {
      server_admin: string,
      sql_auth_types: string,
      sql_connect_info: array_of(string),
      sql_default_uid: integer,
      sql_default_gid: integer,
      sql_default_homedir: string,
      virtual_host_ftp: string,
      virtual_host_sftp: string
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

file '/etc/ssh/ssh_host_rsa_key' do
  action :nothing
  mode '0600'
  owner 'root'
  group 'ssh_keys'
end
