require 'git'
require 'tmpdir'

module Imagemaster3000
  module Definitions
    class Downloader
      def initialize(git_repository)
        @dir = Dir.mktmpdir 'imagemaster3000-'
        logger.debug "Downloading definitions repository #{git_repository}"
        @git = Git.clone(git_repository, 'definitions', path: @dir)
      end

      def path
        @git.dir.path
      end

      def clean
        logger.debug "Cleaning definitions #{@dir}"
        FileUtils.remove_entry @dir
      end
    end
  end
end
