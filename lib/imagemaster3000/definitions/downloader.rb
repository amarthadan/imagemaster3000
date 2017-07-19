require 'git'
require 'tmpdir'

module Imagemaster3000
  module Definitions
    class Downloader
      def self.download_definitions
        tmp_dir = Dir.mktmpdir 'imagemaster3000-'
        logger.debug "Downloading definitions repository #{Imagemaster3000::Settings['definitions-repository']}"
        Imagemaster3000::Entities::Definitions.new(Git.clone(Imagemaster3000::Settings['definitions-repository'],
                                                             File.basename(tmp_dir),
                                                             path: File.dirname(tmp_dir)))
      end
    end
  end
end
