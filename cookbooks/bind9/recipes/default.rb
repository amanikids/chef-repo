package 'bind9'

service 'bind9' do
  action :enable
  supports :restart => true, :status => true, :reload => true
end

template '/etc/bind/named.conf.local' do
  source 'named.conf.local.erb'
  mode 0644
  owner 'root'
  group 'bind'
  notifies :reload, resources(:service => 'bind9')
end

template '/etc/bind/named.conf.options' do
  source 'named.conf.options.erb'
  mode 0644
  owner 'root'
  group 'bind'
  notifies :reload, resources(:service => 'bind9')
end

node[:bind9][:zones].each do |zone, attributes|
  network = attributes[:network]
  hosts   = attributes[:hosts]

  template "/etc/bind/db.#{zone}" do
    source 'db.forward.erb'
    mode 0644
    owner 'root'
    group 'bind'
    variables :zone => zone, :hosts => hosts
    notifies :reload, resources(:service => 'bind9')
  end

  template "/etc/bind/db.#{network}" do
    source 'db.reverse.erb'
    mode 0644
    owner 'root'
    group 'bind'
    variables :zone => zone, :hosts => hosts, :network => network
    notifies :reload, resources(:service => 'bind9')
  end
end
