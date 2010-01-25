package 'dhcp3-server'

service 'dhcp3-server' do
  supports :restart => true, :status => true
end

template '/etc/dhcp3/dhcpd.conf' do
  source 'dhcpd.conf.erb'
  mode 0644
  owner 'root'
  group 'root'
  notifies :restart, resources(:service => 'dhcp3-server')
end
