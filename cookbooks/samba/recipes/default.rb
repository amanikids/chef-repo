package 'samba'

service 'samba' do
  action :enable
  supports :restart => true, :status => true, :reload => true
end

template '/etc/samba/smb.conf' do
  source 'smb.conf.erb'
  mode 0644
  owner 'root'
  group 'root'
  notifies :restart, resources(:service => 'samba')
end

node[:samba][:shares].each do |sharename, attributes|
  directory "/var/lib/samba/shares/#{sharename}" do
    mode 0755
    owner 'nobody'
    group 'nogroup'
    recursive true
  end

  attributes[:users].each do |username|
    user username do
      home '/nonexistent'
      shell '/bin/false'
    end

    execute "/usr/bin/smbpasswd -n -a #{username}" do
      not_if "/bin/grep #{username} /etc/samba/smbpasswd"
    end
  end
end

