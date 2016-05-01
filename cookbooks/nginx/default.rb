package 'http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm' do
  not_if 'rpm -q nginx-release-centos'
end

package 'nginx'

service 'nginx' do
  action [:enable, :start]
end

template '/etc/nginx/conf.d/default.conf' do
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[nginx]'
end
