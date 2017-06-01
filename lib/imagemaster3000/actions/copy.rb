module Imagemaster3000
  module Actions
    class Copy
      attr_accessor :source, :target

      def initialize(source: nil, target: nil)
        raise Imagemaster3000::Errors::ArgumentError, 'neither source nor target can be nil' if source.empty? || target.empty?

        @source = source
        @target = File.join(Imagemaster3000::Settings[:'definitions-dir'], target)
        logger.debug "Created action #{inspect}"
      end

      def run(image_file)
        logger.debug "Running 'copy' action with source #{source.inspect} and target #{target.inspect} on file #{image_file.inspect}"
        Imagemaster3000::Utils::CommandExecutioner.execute Imagemaster3000::Settings[:'binaries-virt-copy-in'],
                                                           '-a',
                                                           image_file,
                                                           source,
                                                           target
      rescue Imagemaster3000::Errors::CommandExecutionError => ex
        raise Imagemaster3000::Errors::ActionError, ex
      end
    end
  end
end
