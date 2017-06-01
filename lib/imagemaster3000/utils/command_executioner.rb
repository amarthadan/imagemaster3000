require 'mixlib/shellout'

module Imagemaster3000
  module Utils
    class CommandExecutioner
      class << self
        def execute(*args)
          command = Mixlib::ShellOut.new(*args)
          logger.debug "Executing command: #{command.command.inspect}"
          command.run_command

          if command.error?
            raise Imagemaster3000::Errors::CommandExecutionError, "Command #{command.command.inspect} terminated with an error: " \
                                                              "#{command.stderr}"
          end

          command.stdout
        end
      end
    end
  end
end
