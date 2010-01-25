dhcpd Mash.new unless attribute?('dhcpd')

raise unless dhcpd.has_key?(:broadcast_address)
raise unless dhcpd.has_key?(:domain_name_servers)
raise unless dhcpd.has_key?(:routers)

dhcpd[:subnets] ||= []
dhcpd[:fixed_addresses] ||= []