package 'http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm' do
  not_if 'rpm -q nginx-release-centos'
end

package 'nginx'

service 'nginx' do
  action [:enable, :start]
end
