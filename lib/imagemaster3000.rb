require 'active_support/all'
require 'gpgme'

module Imagemaster3000
  autoload :CLI, 'imagemaster3000/cli'
  autoload :Settings, 'imagemaster3000/settings'
  autoload :Cleaner, 'imagemaster3000/cleaner'
  autoload :MainProcess, 'imagemaster3000/main_process'

  autoload :Errors, 'imagemaster3000/errors'
  autoload :Entities, 'imagemaster3000/entities'
  autoload :Verification, 'imagemaster3000/verification'
  autoload :Actions, 'imagemaster3000/actions'
  autoload :Utils, 'imagemaster3000/utils'
  autoload :ImageList, 'imagemaster3000/image_list'
  autoload :Definitions, 'imagemaster3000/definitions'
end

require 'imagemaster3000/version'
