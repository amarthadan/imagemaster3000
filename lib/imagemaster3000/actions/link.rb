module Imagemaster3000
  module Actions
    class Link
      attr_accessor :target, :link, :symbolic

      def initialize(target: nil, link: nil, symbolic: false)
        raise Imagemaster3000::Errors::ArgumentError, 'neither target nor link can be nil' if target.empty? || link.empty?

        @target = target
        @link = link
        @symbolic = symbolic
        logger.debug "Created action #{inspect}"
      end

      def run(image_file)
        logger.debug "Running 'link' action with target #{target.inspect} and link #{link.inspect} on file #{image_file.inspect}"
        ln image_file
      rescue Imagemaster3000::Errors::CommandExecutionError => ex
        raise Imagemaster3000::Errors::ActionError, ex
      end

      def ln(image_file)
        ln_command = symbolic ? 'ln-s' : 'ln'

        Imagemaster3000::Utils::CommandExecutioner.execute Imagemaster3000::Settings[:'binaries-guestfish'],
                                                           '-a',
                                                           image_file,
                                                           '-i',
                                                           ln_command,
                                                           target,
                                                           link
      end
    end
  end
end
