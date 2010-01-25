# This file is a HACK that allows Sprinkle to operate net-free. It assumes
# you've already uploaded the proper packages onto the system.
require 'sprinkle/installers/gem'
require 'sprinkle/installers/source'

module Sprinkle::Installers
  class Gem < Installer
    def install_commands
      "bash -c 'cd /usr/local/src && gem install #{@package.name} --local'"
    end
  end

  class Source < Installer
    def download_commands
      []
    end
  end
end
