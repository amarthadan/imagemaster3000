require 'settingslogic'

module Imagemaster3000
  class Settings < Settingslogic
    CONFIGURATION = 'imagemaster3000.yml'.freeze

    # three possible configuration file locations in order by preference
    # if configuration file is found rest of the locations are ignored
    source "#{ENV['HOME']}/.imagemaster3000/#{CONFIGURATION}"\
    if File.exist?("#{ENV['HOME']}/.imagemaster3000/#{CONFIGURATION}")

    source "/etc/imagemaster3000/#{CONFIGURATION}"\
    if File.exist?("/etc/imagemaster3000/#{CONFIGURATION}")

    source "#{File.dirname(__FILE__)}/../../config/#{CONFIGURATION}"

    namespace 'imagemaster3000'
  end
end
