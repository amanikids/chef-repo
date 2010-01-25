iptables Mash.new unless attribute?('iptables')

iptables[:allow_internet_access_for] ||= {}
iptables[:enable_forwarding] = '0'

unless iptables[:allow_internet_access_for].empty?
  iptables[:enable_forwarding] = '1'
  iptables[:upstream]   ||= 'eth0'
  iptables[:downstream] ||= 'eth1'
end
