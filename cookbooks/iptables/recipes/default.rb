package 'iptables'

service 'procps' do
  action :enable
  supports :restart => true
end

template '/etc/sysctl.d/60-network-forwarding.conf' do
  source 'network-forwarding.conf.erb'
  mode 0644
  owner 'root'
  group 'root'
  notifies :restart, resources(:service => 'procps')
end

execute 'iptables-restore' do
  command '/sbin/iptables-restore < /etc/network/iptables'
  action :nothing
end

template '/etc/network/iptables' do
  source 'iptables.erb'
  mode 0644
  owner 'root'
  group 'root'
  notifies :run, resources(:execute => 'iptables-restore')
end

template '/etc/network/if-pre-up.d/iptables-restore' do
  source 'iptables-restore.erb'
  mode 0755
  owner 'root'
  group 'root'
end
