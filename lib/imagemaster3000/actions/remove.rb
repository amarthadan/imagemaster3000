module Imagemaster3000
  module Actions
    class Remove
      attr_accessor :file

      def initialize(file)
        @file = file
        logger.debug "Created action #{inspect}"
      end

      def run(image_file)
        logger.debug "Running 'remove' action with argument #{file.inspect} on file #{image_file.inspect}"
        Imagemaster3000::Utils::CommandExecutioner.execute Imagemaster3000::Settings[:'binaries-guestfish'],
                                                           '-a',
                                                           image_file,
                                                           '-i',
                                                           'rm',
                                                           file
      rescue Imagemaster3000::Errors::CommandExecutionError => ex
        raise Imagemaster3000::Errors::ActionError, ex
      end
    end
  end
end
