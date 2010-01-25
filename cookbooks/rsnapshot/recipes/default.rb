package 'rsnapshot'

template '/etc/rsnapshot.conf' do
  source 'rsnapshot.conf.erb'
  mode 0644
  owner 'root'
  group 'root'
end

remote_file '/etc/cron.d/rsnapshot' do
  source 'rsnapshot'
  mode 0644
  owner 'root'
  group 'root'
  backup false
end
