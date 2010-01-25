files = File.join(File.dirname(__FILE__), '..', 'files', 'default')

Dir.glob("#{files}/*.gem").each do |file|
  remote_file "/usr/local/src/#{File.basename(file)}" do
    source File.basename(file)
    mode 0644
    owner 'root'
    group 'root'
  end
end

execute "install_local_mysql_gem" do
  command 'cd /usr/local/src; gem install mysql --local'
  not_if 'gem list --local | grep mysql'
end
