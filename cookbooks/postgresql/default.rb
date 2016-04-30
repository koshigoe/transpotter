package 'https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm' do
  not_if 'rpm -q pgdg-centos95'
end

package 'postgresql95'
package 'postgresql95-server'
package 'postgresql95-devel'
package 'postgresql95-contrib'

service 'postgresql-9.5' do
  action [:enable]
end

execute '/usr/pgsql-9.5/bin/postgresql95-setup initdb' do
  notifies :start, 'service[postgresql-9.5]'
  not_if '/usr/pgsql-9.5/bin/postgresql95-check-db-dir /var/lib/pgsql/9.5/data'
end
