include_recipe "ruby"

%w{ apache2-prefork-dev libapr1-dev }.each do |pkg|
  package pkg do
    action :upgrade
  end
end

files = File.join(File.dirname(__FILE__), '..', 'files', 'default')

Dir.glob("#{files}/*.gem").each do |file|
  remote_file "/usr/local/src/#{File.basename(file)}" do
    source File.basename(file)
    mode 0644
    owner 'root'
    group 'root'
  end
end

execute "install_local_passenger_gem" do
  command 'cd /usr/local/src; gem install passenger --local'
  creates '/usr/bin/passenger-install-apache2-module'
end

execute "passenger_module" do
  command 'echo -en "\n\n\n\n" | passenger-install-apache2-module'
  creates node[:passenger][:module_path]
end

%w(load conf).each do |extension|
  template "/etc/apache2/mods-available/passenger.#{extension}" do
    source "passenger.#{extension}.erb"
    mode 0644
    owner 'root'
    group 'root'
  end
end

apache_module 'passenger'
