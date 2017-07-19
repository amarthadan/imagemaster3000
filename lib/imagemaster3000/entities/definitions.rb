module Imagemaster3000
  module Entities
    class Definitions
      def initialize(repository)
        @repository = repository

        self.branch = Imagemaster3000::Settings['definitions-branch'] if Imagemaster3000::Settings['definitions-branch']
      end

      def path
        @repository.dir.path
      end

      def branch=(branch)
        raise Imagemaster3000::Errors::ArgumentError, "no such branch #{branch.inspect}" unless @repository.is_branch? branch

        logger.debug "Changing branch to #{branch}"
        @repository.checkout branch
      end

      def clean
        logger.debug "Cleaning definitions #{@directory}"
        FileUtils.remove_entry path
      end
    end
  end
end
