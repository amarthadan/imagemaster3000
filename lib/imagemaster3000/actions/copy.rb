module Imagemaster3000
  module Actions
    class Copy
      attr_accessor :filename, :source, :target, :name

      def initialize(source: nil, target: nil, name: nil)
        raise Imagemaster3000::Errors::ArgumentError, 'neither source nor target can be nil' if source.empty? || target.empty?

        @filename = source
        @source = File.join(Imagemaster3000::Settings[:'definitions-dir'], 'files', source)
        @target = target
        @name = name
        logger.debug "Created action #{inspect}"
      end

      def run(image_file)
        logger.debug "Running 'copy' action with source #{source.inspect} and target #{target.inspect} on file #{image_file.inspect}"
        copy image_file
        rename image_file if name
      rescue Imagemaster3000::Errors::CommandExecutionError => ex
        raise Imagemaster3000::Errors::ActionError, ex
      end

      private

      def copy(image_file)
        Imagemaster3000::Utils::CommandExecutioner.execute Imagemaster3000::Settings[:'binaries-virt-copy-in'],
                                                           '-a',
                                                           image_file,
                                                           source,
                                                           target
      end

      def rename(image_file)
        Imagemaster3000::Utils::CommandExecutioner.execute Imagemaster3000::Settings[:'binaries-guestfish'],
                                                           '-a',
                                                           image_file,
                                                           '-i',
                                                           'mv',
                                                           File.join(target, filename),
                                                           File.join(target, name)
      end
    end
  end
end
