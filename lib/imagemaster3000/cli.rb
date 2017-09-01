require 'thor'
require 'yell'

module Imagemaster3000
  class CLI < Thor
    class_option :'logging-level',
                 required: true,
                 default: Imagemaster3000::Settings['logging']['level'],
                 type: :string,
                 enum: Yell::Severities
    class_option :'logging-file',
                 default: Imagemaster3000::Settings['logging']['file'],
                 type: :string,
                 desc: 'File to write logs to'
    class_option :debug,
                 default: Imagemaster3000::Settings['debug'],
                 type: :boolean,
                 desc: 'Runs in debug mode'

    method_option :'definitions-repository',
                  default: Imagemaster3000::Settings['definitions']['repository'],
                  type: :string,
                  required: true,
                  desc: 'Repository from which image definitions will be downloaded'
    method_option :'definitions-branch',
                  default: Imagemaster3000::Settings['definitions']['branch'],
                  type: :string,
                  desc: 'Repository branch that will be used'
    method_option :'image-dir',
                  default: Imagemaster3000::Settings['image-dir'],
                  type: :string,
                  required: true,
                  desc: 'Directory where to temporarily store images'
    method_option :group,
                  required: true,
                  default: Imagemaster3000::Settings['group'],
                  type: :string,
                  desc: 'Group, images will be uploaded to'
    method_option :'image-list-path',
                  required: true,
                  default: Imagemaster3000::Settings['image-list']['path'],
                  type: :string,
                  desc: 'Name and path of generated image list'      
    method_option :'image-list-description',
                  required: true,
                  default: Imagemaster3000::Settings['image-list']['description'],
                  type: :string,
                  desc: 'Imagelist description required by cloudkeeper'
    method_option :'image-list-identifier',
                  required: true,
                  default: Imagemaster3000::Settings['image-list']['identifier'],
                  type: :string,
                  desc: 'Imagelist identifier required by cloudkeeper'
    method_option :'image-list-source',
                  required: true,
                  default: Imagemaster3000::Settings['image-list']['source'],
                  type: :string,
                  desc: 'Imagelist source required by cloudkeeper'
    method_option :'image-list-mpuri',
                  required: true,
                  default: Imagemaster3000::Settings['image-list']['mpuri'],
                  type: :string,
                  desc: 'Imagelist mpuri required by cloudkeeper'

    method_option :endpoint,
                  required: true,
                  default: Imagemaster3000::Settings['endpoint'],
                  type: :string,
                  desc: 'Endpoint where image list will be available'
    method_option :certificate,
                  required: true,
                  default: Imagemaster3000::Settings['certificate'],
                  type: :string,
                  desc: 'Certificate to sign image list with'
    method_option :key,
                  required: true,
                  default: Imagemaster3000::Settings['key'],
                  type: :string,
                  desc: 'Key to sign image list with'
    method_option :'binaries-virt-copy-in',
                  required: true,
                  default: Imagemaster3000::Settings['binaries']['virt-copy-in'],
                  type: :string,
                  desc: 'Path to binary needed for \'copy\' action'
    method_option :'binaries-guestfish',
                  required: true,
                  default: Imagemaster3000::Settings['binaries']['guestfish'],
                  type: :string,
                  desc: 'Path to binary needed for \'remove\' action'

    desc 'start', 'Downloads images and generates image list'
    def start
      initialize_configuration options
      initialize_logger
      logger.debug "Imagemaster3000 'start' called with parameters: #{Imagemaster3000::Settings.to_hash.inspect}"

      Imagemaster3000::MainProcess.new.run
    end

    desc 'version', 'Prints imagemaster3000 version'
    def version
      $stdout.puts Imagemaster3000::VERSION
    end

    default_task :start

    private

    def initialize_configuration(options)
      Imagemaster3000::Settings.clear
      Imagemaster3000::Settings.merge! options.to_hash
    end

    def initialize_logger
      Imagemaster3000::Settings[:'logging-level'] = 'DEBUG' if Imagemaster3000::Settings[:debug]

      logging_file = Imagemaster3000::Settings[:'logging-file']
      logging_level = Imagemaster3000::Settings[:'logging-level']

      Yell.new :stdout, name: Object, level: logging_level.downcase, format: Yell::DefaultFormat
      Object.send :include, Yell::Loggable

      setup_file_logger(logging_file) if logging_file

      logger.debug 'Running in debug mode...'
    end

    def setup_file_logger(logging_file)
      unless (File.exist?(logging_file) && File.writable?(logging_file)) || File.writable?(File.dirname(logging_file))
        logger.error "File #{logging_file} isn't writable"
        return
      end

      logger.adapter :file, logging_file
    end
  end
end
