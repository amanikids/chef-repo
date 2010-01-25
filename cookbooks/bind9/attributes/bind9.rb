bind9 Mash.new unless attribute?('bind9')

bind9[:forwarders] ||= []
bind9[:listen_on]  ||= []
bind9[:zones]      ||= []
