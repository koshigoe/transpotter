package 'https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm' do
  not_if 'rpm -q pgdg-centos95'
end

package 'postgresql95'
package 'postgresql95-contrib'
