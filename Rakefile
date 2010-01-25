require 'vendor/gems/environment'

$LOAD_PATH.unshift('lib')

require 'sprinkle'
require 'sprinkle/local'
require 'tmpdir'

desc 'Install chef.'
task :bootstrap do
  Sprinkle::Script.sprinkle File.read('config/bootstrap.rb')
end

desc 'Deploy and run the latest chef recipes.'
task :deploy do
  Dir.mktmpdir do |temporary_directory|
    sh "tar czf #{temporary_directory}/recipes.tgz cookbooks"

    # Sprinkle barfs if you've required capistrano, so we have to do it here
    # rather than at the top level.
    require 'capistrano'
    cap = Capistrano::Configuration.new
    cap.logger.level = 1
    cap.load 'config/deploy'

    cap.load do
      task :converge do
        upload 'config/solo.rb',       '/etc/chef/solo.rb'
        upload "nodes/mchungaji.json", '/etc/chef/node.json'
        upload "#{temporary_directory}/recipes.tgz", '/usr/local/src/recipes.tgz'
        run 'chef-solo --json-attributes /etc/chef/node.json --recipe-url /usr/local/src/recipes.tgz'
      end
    end

    cap.converge
  end
end
