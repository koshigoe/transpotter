include_recipe './default.rb'

package 'postgresql95-server'

service 'postgresql-9.5' do
  action [:enable]
end

execute '/usr/pgsql-9.5/bin/postgresql95-setup initdb' do
  notifies :start, 'service[postgresql-9.5]'
  not_if '/usr/pgsql-9.5/bin/postgresql95-check-db-dir /var/lib/pgsql/9.5/data'
end

remote_file '/var/lib/pgsql/9.5/data/pg_hba.conf' do
  owner 'postgres'
  group 'postgres'
  mode '0600'
  notifies :restart, 'service[postgresql-9.5]'
end

remote_file '/var/lib/pgsql/9.5/data/postgresql.conf' do
  owner 'postgres'
  group 'postgres'
  mode '0600'
  notifies :restart, 'service[postgresql-9.5]'
end

