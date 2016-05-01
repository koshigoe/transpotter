include_recipe '../postgresql/devel.rb'

package 'https://github.com/feedforce/ruby-rpm/releases/download/2.3.1/ruby-2.3.1-1.el7.centos.x86_64.rpm' do
  not_if 'rpm -q ruby'
end

execute 'gem install bundler -v1.12.1 --no-document' do
  not_if 'gem list -i ^bundler$ -v1.12.1'
end

package 'gcc'
package 'postgresql95-devel'
package 'libxml2-devel'
package 'libxslt-devel'
