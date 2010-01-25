samba Mash.new unless attribute?(:samba)

samba[:workgroup] ||= 'WORKGROUP'
samba[:listen_interfaces] ||= []
samba[:shares] ||= []
