package 'ruby'
package 'ruby1.8'
package 'ruby1.8-dev'
package 'rdoc1.8'
package 'ri1.8'
package 'libopenssl-ruby'

gem_package 'rubygems-update' do
  version '1.3.7'
end

execute 'update rubygems' do
  command 'update_rubygems'
  not_if 'gem -v | grep 1.3.7'
end

gem_package 'bundler' do
  version '1.0.0.rc.5'
end
