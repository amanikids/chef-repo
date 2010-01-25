role :target, ENV['HOST'] || 'mchungaji.amani', :user => 'root'

# This before_install hook copies over your ssh public key, so you won't have
# to keep typing in your password.
before :install_build_essential do
  run 'mkdir -p .ssh'
  upload File.expand_path('~/.ssh/id_rsa.pub'), '.ssh/authorized_keys'
end

# These before_install hooks copy the appropriate sources to the remote
# servers, so that we can run sprinkle without needing the net.
before :install_rubygems do
  upload 'vendor/rubygems-1.3.5.tgz', '/usr/local/src/rubygems-1.3.5.tgz'
end

before :install_chef do
  Dir.glob('vendor/gems/ruby/1.8/gems/*.gem').each do |file|
    upload file, "/usr/local/src/#{File.basename(file)}"
  end
end
