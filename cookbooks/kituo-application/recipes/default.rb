user 'deploy' do
  home '/var/www/apps'
end

# TODO if we could get chef to use "adduser" instead of "useradd", this would be unnecessary.
directory '/var/www/apps' do
  owner 'deploy'
  group 'deploy'
end

directory '/var/www/apps/git' do
  owner 'deploy'
  group 'deploy'
end

execute 'create bare kituo git repository' do
  command 'git-init'
  creates '/var/www/apps/git/kituo.git'
  cwd '/var/www/apps/git'
  environment 'GIT_DIR' => 'kituo.git'
  group 'deploy'
  user 'deploy'
end

# TODO is there a better way? Some global form of authorized_keys?
execute 'copy authorized_keys' do
  command 'mkdir /var/www/apps/.ssh; cp /root/.ssh/authorized_keys /var/www/apps/.ssh/authorized_keys; chown -R deploy:deploy /var/www/apps/.ssh'
  creates '/var/www/apps/.ssh/authorized_keys'
end

%w(staging production).each do |environment|
  execute "create kituo_#{environment} database" do
    command "mysqladmin create kituo_#{environment}"
    not_if "mysqlshow | grep kituo_#{environment}"
  end

  kituo_server_name = case environment
    when 'production'
      'kituo.amani'
    when 'staging'
      'kituo-mazoezi.amani'
    else
      "kituo-#{environment}.amani"
    end

  web_app "kituo_#{environment}" do
    template 'kituo_virtual_host.conf.erb'
    docroot "/var/www/apps/kituo_#{environment}/current/public"
    server_name kituo_server_name
    rails_env environment
  end
end

gem_package 'bundler' do
  source 'http://gemcutter.org'
  version '0.6.0'
end
