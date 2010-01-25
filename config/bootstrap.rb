package :build_essential do
  apt 'build-essential'
  verify { has_executable 'make' }
end

package :ruby do
  apt %w(ruby ruby1.8-dev libopenssl-ruby1.8)
  verify { has_executable 'ruby' }
end

package :rubygems do
  requires :build_essential, :ruby
  source 'http://rubyforge.org/frs/download.php/60718/rubygems-1.3.5.tgz' do
    custom_install 'ruby setup.rb --no-rdoc --no-ri'
    post :install, 'ln -sfv /usr/bin/gem1.8 /usr/bin/gem', 'echo "gem: --no-rdoc --no-ri" | tee /etc/gemrc'
  end
  verify { has_executable 'gem' }
end

package :chef do
  requires :rubygems
  gem 'chef' do
    pre  :install, 'gem sources --add http://gems.opscode.com/'
    post :install, 'mkdir /etc/chef'
  end
  verify { has_executable 'chef-solo' }
end

policy :chef, :roles => :target do
  requires :chef
end

deployment do
  delivery :capistrano do
    recipes 'config/deploy'
  end

  source do
    prefix   '/usr/local'
    archives '/usr/local/src'
    builds   '/usr/local/src'
  end
end
