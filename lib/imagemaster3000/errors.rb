module Imagemaster3000
  module Errors
    autoload :StandardError, 'imagemaster3000/errors/standard_error'
    autoload :ArgumentError, 'imagemaster3000/errors/argument_error'
    autoload :CommandExecutionError, 'imagemaster3000/errors/command_execution_error'
    autoload :ActionError, 'imagemaster3000/errors/action_error'
    autoload :VerificationError, 'imagemaster3000/errors/verification_error'
    autoload :DownloadError, 'imagemaster3000/errors/download_error'
    autoload :ParsingError, 'imagemaster3000/errors/parsing_error'
  end
end
